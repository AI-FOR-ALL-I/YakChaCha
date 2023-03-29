from .get_cli_args import get_cli_args
import torch
import torch.nn as nn
from torch.utils.data import Dataset, DataLoader
from torchvision import transforms, models
import torch.optim as optim
import torch.backends.cudnn as cudnn
from torch.optim.lr_scheduler import ReduceLROnPlateau

from .gen_pill import Gen_Digit
# from hrnet import get_hrnet
from .utils import model_load, model_save, accuracy, get_optimizer, transform_normalize, AverageMeter, adjust_learning_rate, read_dict_from_json
import time
from tqdm import tqdm
from torch.utils.tensorboard import SummaryWriter
import os
import datetime


class Dataset_Pill(Dataset):
    def __init__(self, args, dir_dataset, transform=None, target_transform=None, run_phase='train'):
        self.args = args
        self.gen_digit = Gen_Digit(args, dir_dataset, run_phase)
        self.transform = transform
        self.target_transform = target_transform
        self.run_phase = run_phase

    def __len__(self):
        return self.gen_digit.len_total

    def __getitem__(self, idx):
        image, label, path_img, aug_name = self.gen_digit.generate_digits_by_index(self.args, idx)

        if self.transform is not None:
            image = self.transform(image)

        if self.target_transform is not None:
            label = self.target_transform(label)
        if self.run_phase == 'valid' or self.run_phase == 'test':
            return image, label, path_img, aug_name
        else:
            return image, label

def get_pill_model(args):

    if args.cnn_name == 'resnet152' :
        
        dict_temp = read_dict_from_json(args.json_pill_label_path_sharp_score)
        list_pill_label_path_sharp_score = dict_temp['pill_label_path_sharp_score']

        list_count = len(list_pill_label_path_sharp_score)
        args.num_classes = list_count

        model = models.resnet152(num_classes=args.num_classes)
    # elif args.cnn_name == 'hrnet_w64' :
    #     model = get_hrnet()
    #     model.classifier = nn.Linear(in_features=2048, out_features=args.num_classes, bias=True)
    else:
        raise Exception('No Found CNN Name')

    if args.cuda == True:
        if args.gpu is not None:
            model.cuda(args.gpu)
        else:
            model.cuda()
    else:
        model.cpu()

    return model



def train(args, dataloader, sampler, model, criterion, optimizer, epoch, log_writer=None, verbose=True):
    model.train()
    if sampler != None:
        sampler.set_epoch(epoch)

    metric_train_loss = AverageMeter()
    ametric_data_time = AverageMeter()

    top1 = AverageMeter()
    top5 = AverageMeter()


    end = time.time()
    lr = optimizer.param_groups[0]['lr']
    with tqdm(total=len(dataloader), desc=args.tqdm_desc_head + 'Train Epoch  #{}'.format(epoch), disable=not verbose) as t:
        for batch_idx, (img, target) in enumerate(dataloader):
            if args.cuda:
                img = img.cuda()
                target = target.cuda()

            optimizer.zero_grad()
            output = model(img)
            loss = criterion(output, target)

            loss.backward()
            optimizer.step()

            prec1, prec5 = accuracy(output, target, (1, 5))
            count_try = img.cpu().shape[0]
            top1.update(prec1[0].detach().cpu().item(), count_try)
            top5.update(prec5[0].detach().cpu().item(), count_try)

            metric_train_loss.update(loss.detach().cpu().item(), count_try)
            t.set_postfix({'loss': metric_train_loss.avg, 'lr':lr,  'top1':top1.avg, 'top5':top5.avg })
            t.update(1)

    ametric_data_time.update(time.time() - end)

    if log_writer:
        log_writer.add_scalar('train/loss', metric_train_loss.avg, epoch)

    try:
        print_string = 'Epoch: [{0}][{1}/{2}]\t'.format(epoch, batch_idx, len(dataloader))
        print_string += 'Data time {data_time.val:.3f} ({data_time.avg:.3f} Now:{Now})\t'.format(data_time=ametric_data_time, Now=datetime.datetime.now())
        print_string += 'Loss {loss.val:.4f} ({loss.avg:.4f})'.format(loss=metric_train_loss)
        print_string += 'Accuracy top1:{top1.avg:.4f}, top5:{top5.avg:.4f}'.format(top1=top1, top5=top5)
        print(print_string)
    except:
        pass

    return metric_train_loss.avg


def valid(args, dataloader, sampler,  model, criterion, epoch, log_writer=None, verbose=True):
    metric_train_loss = AverageMeter()
    ametric_data_time = AverageMeter()

    top1 = AverageMeter()
    top5 = AverageMeter()
    if sampler != None:
        sampler.set_epoch(epoch)
    model.eval()
    
    
    args.dict_idx_itemid = {}
    dict_temp = read_dict_from_json(args.json_pill_label_path_sharp_score)
    list_pill_label_path_sharp_score = dict_temp['pill_label_path_sharp_score']
    list_count = len(list_pill_label_path_sharp_score)
    for idx in range(list_count):
        args.dict_idx_itemid[idx] = list_pill_label_path_sharp_score[idx][1]
    
    end = time.time()
    args.path_img = []
    args.list_preds = []
    args.list_target = []
    args.count_correct = 0
    with torch.no_grad():
        with tqdm(total=len(dataloader), desc=args.tqdm_desc_head + '{} Epoch  #{}'.format( args.run_phase, epoch), disable=not verbose) as t:
            for i, (img, target, path_img, aug_name ) in enumerate(dataloader):
                # measure data loading time
                if args.cuda:
                    img = img.cuda()
                    target = target.cuda()

                output = model(img)
                loss = criterion(output, target)

                prec1, prec5 = accuracy(output, target, (1, 5))

                if ( prec1[0].detach().cpu().item() != 100.):
                    if args.run_phase == 'valid': print(f'<------- class valid fail file: {path_img[0]}, aug_name:{aug_name}')

                preds = output.data.max(dim=1, keepdim=True)[1]
                count_correct = preds.eq(target.data.view_as(preds)).cpu().sum()
                list_preds = preds.view(-1).tolist()

                args.path_img = list(path_img)
                args.list_preds = list_preds
                args.list_target = target.detach().cpu().tolist()
                args.count_correct = count_correct.item()
                count_try = img.cpu().shape[0]
                top1.update(prec1[0].detach().cpu().item(), count_try)
                top5.update(prec5[0].detach().cpu().item(), count_try)

                metric_train_loss.update(loss.detach().cpu().item(), count_try)

                t.set_postfix({'loss': metric_train_loss.avg, 'top1': top1.avg, 'top5': top5.avg})
                t.update(1)

    ametric_data_time.update(time.time() - end)

    if log_writer:
        log_writer.add_scalar('validation/loss', metric_train_loss.avg, epoch)

    try:
        print_string = 'Epoch: [{0}][{1}/{2}]\t'.format(epoch, i, len(dataloader))
        print_string += 'Data time {data_time.val:.3f} ({data_time.avg:.3f} Now:{Now})\t'.format(data_time=ametric_data_time, Now=datetime.datetime.now())
        print_string += 'Loss {loss.val:.4f} ({loss.avg:.4f})'.format(loss=metric_train_loss)
        print_string += 'Accuracy top1:{top1.avg:.4f}, top5:{top5.avg:.4f}'.format(top1=top1, top5=top5)
        print(print_string)
    except:
        pass

    return metric_train_loss.avg

def run_model(args, model, dataloader_train, dataloader_valid, sampler_train, sampler_valid, criterion,optimizer, epoch_begin, log_writer, verbose=True  ):
    if args.run_phase == 'valid' or args.run_phase == 'test':
        print(time.asctime())
        valid(args, dataloader_valid, sampler_valid,  model, criterion, 0, log_writer)
        print(time.asctime())
        return

    lr_scheduler = ReduceLROnPlateau(optimizer, mode='min', factor=0.8, patience=2, verbose=True, threshold=0.0001, threshold_mode='rel', cooldown=3, min_lr=0, eps=1e-08)


    best_perf = 1000
    for epoch in range(epoch_begin, args.epochs):   # ( 0:100)
        # adjust_learning_rate(args, optimizer, epoch)
        # train for one epoch
        perf_indicator = train(args, dataloader_train, sampler_train, model, criterion, optimizer, epoch, log_writer, verbose)
        if epoch > 10:
            perf_indicator = valid(args, dataloader_valid,sampler_valid, model, criterion, epoch, log_writer,verbose)
            if (args.gpu == 0):
                print(f'perf_indicator:{perf_indicator} ,  best_perf:{best_perf}')
            if perf_indicator < best_perf:
                model_save(args.model_path, epoch, model, optimizer, args.rank)
                best_perf = perf_indicator
        else:
            model_save(args.model_path, epoch, model, optimizer, args.rank)
            best_perf = perf_indicator

        lr_scheduler.step(perf_indicator)


model = None
criterion = None
optimizer = None
epoch_begin = 0
log_writer = None

def pill_classifier(args):
    global model, criterion, optimizer, epoch_begin, log_writer
    if args.dataset_valid != None:
        dataloader_valid = DataLoader(args.dataset_valid, batch_size=args.batch_size, shuffle= False, num_workers=args.num_workers)
    else:
        dataloader_valid = None

    if args.run_phase == 'train' and args.dataset_train != None:
        dataloader_train = DataLoader(args.dataset_train, batch_size=args.batch_size, shuffle=True, num_workers=args.num_workers)
    else:
        dataloader_train = None

    if model == None :
        log_writer = SummaryWriter(args.dir_log)
        if args.cuda == False or torch.cuda.device_count() == 0  :
            args.gpu = None
        else:
            args.gpu = 0

        args.rank = args.gpu

        cudnn.benchmark = True
        torch.backends.cudnn.deterministic = False
        torch.backends.cudnn.enabled = True

        model = get_pill_model(args)

        # define loss function (criterion) and optimizer
        criterion = torch.nn.CrossEntropyLoss()
        if args.cuda:
            criterion = criterion.cuda()
        optimizer = get_optimizer(args,model)
        epoch_begin, dict_checkpoint, success = model_load(args, model, optimizer)

    run_model(args, model, dataloader_train, dataloader_valid, None, None,  criterion,optimizer, epoch_begin, log_writer )


if __name__ == '__main__':
    # job = 'hrnet_w64'
    job = 'resnet152'
    args = get_cli_args(job=job, run_phase='test', aug_level=0, dataclass='0')

    print(f'model_path_in is {args.model_path_in}')

    end = time.time()
    if args.run_phase == 'train'  :
        args.dataset_train = Dataset_Pill(args, args.json_pill_class_list,  transform=transform_normalize, run_phase='train')
        print(f'train dataset was loaded')

    args.dataset_valid = Dataset_Pill(args, args.json_pill_class_list, transform=transform_normalize, run_phase='test' if args.run_phase == 'test' else 'valid')
    print(f'valid dataset was loaded')


    print(f'dataset loading time is {time.time() - end}')

    pill_classifier(args)
    print('job done')