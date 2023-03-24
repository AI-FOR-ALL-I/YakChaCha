from get_cli_args import get_cli_args
import torch
import torch.nn as nn
from torch.utils.data import Dataset, DataLoader
from torchvision import transforms, models
import torch.optim as optim
import torch.backends.cudnn as cudnn
from torch.optim.lr_scheduler import ReduceLROnPlateau

# from hrnet import get_hrnet
from utils import model_load, transform_normalize, get_optimizer
import time
from tqdm import tqdm
from torch.utils.tensorboard import SummaryWriter
import torch.multiprocessing as mp
from pill_classifier import get_pill_model, Dataset_Pill, run_model
import horovod.torch as hvd


def adjust_learning_rate_hvd(args, optimizer, len_loader, epoch, batch_idx):
    if epoch < args.warmup_epochs:
        epoch += float(batch_idx + 1) / len_loader
        lr_adj = 1. / hvd.size() * (epoch * (hvd.size() - 1) / args.warmup_epochs + 1)
    elif epoch < 30:
        lr_adj = 1.
    elif epoch < 60:
        lr_adj = 1e-1
    elif epoch < 80:
        lr_adj = 1e-2
    else:
        lr_adj = 1e-3

    lr = args.base_lr * hvd.size() * args.batches_per_allreduce * lr_adj
    for param_group in optimizer.param_groups:
        param_group['lr'] = lr

    return lr

def pill_classifier_hvd(args):
    # pytorch의 DataLoader 함수를 사용할 때 num_workers>1인 경우를  지원해서, fork가 지원되게.
    torch.multiprocessing.freeze_support()
    print(f'model path is {args.model_path_in}')

    args.allreduce_batch_size = args.batch_size * args.batches_per_allreduce

    hvd.init()
    torch.manual_seed(args.seed)

    if args.cuda:
        # Horovod: pin GPU to local rank.
        torch.cuda.set_device(hvd.local_rank())
        torch.cuda.manual_seed(args.seed)
        args.gpu = hvd.local_rank()

    cudnn.benchmark = True  # 내장된 cudnn 자동 튜너를 활성화하여, 하드웨어에 맞게 사용할 최상의 알고리즘(텐서 크기나 conv 연산에 맞게?)을 찾는다.
                            # 입력 이미지 크기가 자주 변하지 않는다면, 초기 시간이 소요되지만 일반적으로 더 빠른 런타임의 효과를 볼 수 있다
    torch.backends.cudnn.deterministic = False      # 만일 True이면, cudnn에 맞추는 알고리즘이 없으면, Raise Error가 된다.
    torch.backends.cudnn.enabled = True

    verbose = args.verbose if hvd.rank() == 0 else False
    args.rank = hvd.rank()

    # Horovod: write TensorBoard logs on first worker.
    log_writer = SummaryWriter(args.dir_log) if hvd.rank() == 0 else None

    # Horovod: limit # of CPU threads to be used per worker.
    torch.set_num_threads(args.num_threads)

    kwargs = {'num_workers': args.num_workers, 'pin_memory': True} if args.cuda else {}

    # When supported, use 'forkserver' to spawn dataloader workers instead of 'fork' to prevent
    # issues with Infiniband implementations that are not fork-safe
    if (kwargs.get('num_workers', 0) > 0 and hasattr(mp, '_supports_context') and
        mp._supports_context and 'forkserver' in mp.get_all_start_methods()):
        kwargs['multiprocessing_context'] = 'forkserver'

    #############################################################################
    print("Loading dataset...")

    if args.run_phase == 'train':
        dataset_train = Dataset_Pill(args, args.json_pill_class_list, transform=transform_normalize, run_phase='train')
        sampler_train = torch.utils.data.distributed.DistributedSampler(dataset_train, num_replicas=hvd.size(), rank=hvd.rank())
        dataloader_train = DataLoader(dataset_train, batch_size=args.batch_size, sampler=sampler_train, **kwargs)

    dataset_valid = Dataset_Pill(args, args.json_pill_class_list, transform=transform_normalize, run_phase='valid')
    sampler_valid = torch.utils.data.distributed.DistributedSampler(dataset_valid, num_replicas=hvd.size(), rank=hvd.rank())
    dataloader_valid = DataLoader(dataset_valid, batch_size=args.batch_size, sampler=sampler_valid, **kwargs)


    model = get_pill_model(args)

    # define loss function (criterion) and optimizer
    criterion = torch.nn.CrossEntropyLoss().cuda()
    optimizer = get_optimizer(args, model)
    compression = hvd.Compression.fp16 if args.fp16_allreduce else hvd.Compression.none

    optimizer = hvd.DistributedOptimizer(
        optimizer, named_parameters=model.named_parameters(),
        compression=compression,
        backward_passes_per_step=args.batches_per_allreduce,
        op=hvd.Adasum if args.use_adasum else hvd.Average,
        gradient_predivide_factor=args.gradient_predivide_factor)

    epoch_begin, dict_checkpoint, success = model_load(args, model, optimizer)
    epoch_begin = hvd.broadcast(torch.tensor(epoch_begin), root_rank=0, name='epoch_begin').item()

    # Horovod: broadcast parameters & optimizer state.
    hvd.broadcast_parameters(model.state_dict(), root_rank=0)
    hvd.broadcast_optimizer_state(optimizer, root_rank=0)           # optimizer.state_dict()가 아니다. optimizer가 들어간다.


    run_model(args, model, dataloader_train, dataloader_valid, sampler_train, sampler_valid, criterion,optimizer, epoch_begin, log_writer, verbose  )




if __name__ == '__main__':
    # job = 'hrnet_w64'
    job = 'resnet152'
    args = get_cli_args(job=job, run_phase='train', aug_level=0, dataclass='0')
    pill_classifier_hvd(args)

    print('job done')