import os
import sys
import torch
import argparse
import uuid

is_debug = True
def debugger_is_active() -> bool:
    """Return if the debugger is currently active"""
    gettrace = getattr(sys, 'gettrace', lambda : None)
    return gettrace() is not None

is_debug = debugger_is_active()
# print(f'is_debug is {is_debug}')        # debug 모드로 시작하면,  is_debug == True 이다.

uuid_node = uuid.getnode()

def get_cli_args(job='resnet152', run_phase = 'train', aug_level=0, dataclass='0'):
    #######################################################################################################
    print(f'job={job} run_phase:{run_phase} aug_level:{aug_level}, dataclass:{dataclass} ')
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.ArgumentDefaultsHelpFormatter, )

    verbose = True
    if os.name == 'posix':
        dir_solution_home = r'./proj_pill'
        BATCH_SIZE = 2
        num_workers = 2
        num_threads = 1
        dist_backend = 'gloo'
        if job == 'resnet152':
            BATCH_SIZE = 12

    else:
        dir_solution_home = r'/home/jupyter-j8a803/proj/proj_pill'
        num_workers = 4
        num_threads = 2
        dist_backend = 'nccl'
#         BATCH_SIZE = 8
        BATCH_SIZE = 2
        # if uuid_node == 274973445269205:        # 광주AI
        #     BATCH_SIZE = 56                     # train+valid:56 (opt을 올리지 않는다.), train:56
        #     if job == 'hrnet_w64':
        #         num_workers = 2
        #         BATCH_SIZE = 32
        #     if job == 'resnet152':
        #         num_workers = 4
        #         BATCH_SIZE = 64
        # elif uuid_node == 274973438730257:      # 광주AI2
        #     BATCH_SIZE = 768
        #     if job == 'paf_vgg19':
        #         BATCH_SIZE = 512


    if run_phase == 'valid'  and run_phase == 'test':
        BATCH_SIZE = 1
        num_workers = 1
        num_threads = 1
        verbose = False

    DIR_DATA = os.path.join(dir_solution_home, 'pill_data')
    DIR_PROJ = os.path.join(dir_solution_home, 'proj_pill')



    # define directory
    dir_pill_class_base = 'pill_data_croped'
    json_pill_label_path_sharp_score = 'pill_label_path_sharp_score.json'
    json_pill_prescription_type = 'pill_prescription_type.json'
    json_pill_class_list = 'pill_class_list.json'
    json_pill_itemseq_dict = 'pill_itemseq_dict.json'

    FITTOSIZE = 224
    gen_type = 'read_only_image'
    dataclass = f'dataclass{dataclass}'

    if job == 'resnet152':
        model_path_in = os.path.join(DIR_PROJ, f'pill_resnet152_{dataclass}_aug{aug_level}.pt')
        model_path = os.path.join(DIR_PROJ, f'pill_resnet152_{dataclass}_aug{aug_level}.pt')



    elif job == 'hrnet_w64':
        model_path_in = os.path.join(DIR_PROJ, f'pill_hrnet_w64_{dataclass}_aug{aug_level}.pt')
        model_path = os.path.join(DIR_PROJ, f'pill_hrnet_w64_{dataclass}_aug{aug_level}.pt')


    #######################################################################################################


    dir_pill_class_base = os.path.join(DIR_DATA, dir_pill_class_base)
    json_pill_label_path_sharp_score = os.path.join(dir_pill_class_base, json_pill_label_path_sharp_score)
    json_pill_prescription_type = os.path.join(dir_pill_class_base, json_pill_prescription_type)
    json_pill_itemseq_dict = os.path.join(DIR_PROJ, json_pill_itemseq_dict)
    dir_output = os.path.join(DIR_DATA, 'output')  # output dir for generation from gauge info
    


    dir_log = './logs'
    file_log = os.path.join(dir_log, f'log-{job}.txt')

    #######################################################################################################
    tqdm_desc_head = f'{job} aug_level:{aug_level} :'
    print(f'BATCH_SIZE:{BATCH_SIZE}, num_workers:{num_workers}, num_threads:{num_threads} ')
    #######################################################################################################
    parser.add_argument('--size_image', default=FITTOSIZE, type=int, help='size of heatmap, vectmap')

    parser.add_argument('--dir_log', default=dir_log, help='tensorboard log directory')
    parser.add_argument('--file_log', default=file_log, help='tensorboard log directory')
    parser.add_argument('--dir_pill_class_base', default=dir_pill_class_base, help='pill class valid directory')
    parser.add_argument('--json_pill_label_path_sharp_score', default=json_pill_label_path_sharp_score, help='pill class sharpness')
    parser.add_argument('--json_pill_prescription_type', default=json_pill_prescription_type, help='pill prescription_type')
    parser.add_argument('--json_pill_itemseq_dict', default=json_pill_itemseq_dict, help='pill itemseq dict')

    parser.add_argument('--pill_dataset_class0', default=[90, 75], help='dataset camera latitude ')
    parser.add_argument('--pill_dataset_class1', default=[70, 60], help='dataset camera latitude')

    parser.add_argument('--pill_dataset_train_rate', default=0.8, help='dataset train rate')
    parser.add_argument('--pill_dataset_valid_rate', default=0.1, help='dataset valid rate')
    parser.add_argument('--pill_dataset_test_rate' , default=0.1, help='dataset test rate')
    parser.add_argument('--num_classes', default=1000, help='pill dataset class number')

    json_pill_class_list  = os.path.join(dir_pill_class_base, json_pill_class_list )
    parser.add_argument('--json_pill_class_list', type=str, default=json_pill_class_list, help='json file for json_pill_class_list ')

    parser.add_argument('--gen_type', default=gen_type, help='image only or annotation file')
    parser.add_argument('--gen_dataclass_sel', default=dataclass, help='class0, class1, class01')
    parser.add_argument('--cnn_name', default=job, help='classifier name')  # resnet152, hrnet_w64

    # Default settings from https://arxiv.org/abs/1706.02677.
    parser.add_argument('--batches_per_allreduce', type=int, default=1, help='number of batches processed locally before executing allreduce across workers; it multiplies total batch size.')
    parser.add_argument('--fp16_allreduce', action='store_true', default=False, help='use fp16 compression during allreduce')
    parser.add_argument('--use_adasum', action='store_true', default=False, help='use adasum algorithm to do reduction')
    parser.add_argument('--gradient_predivide_factor', type=float, default=1.0, help='apply gradient predivide factor in optimizer (default: 1.0)')
    parser.add_argument('--wd', type=float, default=0.0001, help='weight decay')
    parser.add_argument('--momentum', type=float, default=0.9, help='SGD momentum')
    parser.add_argument('--warmup_epochs', type=float, default=5, help='number of warmup epochs')
    parser.add_argument('--epochs', type=int, default=150, help='number of epochs to train')
    parser.add_argument('--disable_cuda', action='store_true', default=False, help='disables CUDA training')

    parser.add_argument('--base_lr', type=float, default=0.001, help='learning rate for a single GPU')
    parser.add_argument('--lr', '--learning_rate', default=0.001, type=float, metavar='LR', help='initial learning rate')
    parser.add_argument('--pre_lr', type=float, default=1e-4, help='pre learning rate')

    parser.add_argument('--lr_schedule', default=[60, 100, 140], help='lr scheduler')
    # parser.add_argument('--lr_schedule', default=[3, ], help='lr scheduler')
    parser.add_argument('--lr_gamma', default=0.1, help='lr scheduler')
    parser.add_argument('--lr_factor', default=0.1, help='lr scheduler')

    parser.add_argument('--batch_size', default=BATCH_SIZE, type=int, help='batch size')
    parser.add_argument('--allreduce_batch_size', default=8, type=int, help='batch size')
    parser.add_argument('--run_phase',  default=run_phase, help='train , valid')
    parser.add_argument('--optimizer', default='sgd', help='select the optimizer in  sgd, adam, rmsprop')


    parser.add_argument('--model_path', default=model_path, type=str, metavar='DIR', help='path to where the model saved')
    parser.add_argument('--model_path_in', default=model_path_in, type=str, metavar='DIR', help='path to where the model saved')

    #######################################################################################################
    #######################################################################################################
    vgg19_path = os.path.join(DIR_PROJ, 'paf_vgg19_level{aug_level}.pt')

    dir_gauge_json = os.path.join(dir_solution_home, '민성기', 'digitGaugeSamples')
    dir_gauge_json = os.path.join(dir_solution_home, '민성기', 'digitGaugeSamples2')
    dir_gauge_json = os.path.join(dir_solution_home, '민성기', 'digitGaugeSamples3')
    dir_gauge_json = os.path.join(dir_solution_home, '민성기', 'digitGaugeTest')
    dir_class_basic = os.path.join(DIR_DATA, 'digit_class_base')
    dir_class_basic_aug = os.path.join(DIR_DATA, 'digit_class_base_aug')

    dir_digit_back = os.path.join(DIR_DATA, 'backimage')  # back image
    dir_digit_anno = os.path.join(DIR_DATA, 'annotation')  # annotation
    dir_digit_annoimage = os.path.join(DIR_DATA, 'annotationImage')  # annotation + image

    dir_digit_paf = os.path.join(DIR_DATA, 'digit_paf_train')  # annotation + image
    dir_digit_heat = os.path.join(DIR_DATA, 'digit_heat_train')  # annotation + image



    parser.add_argument('--pre_n_images', default=8000, type=int, help='number of images to sampe for pretraining')
    parser.add_argument('--n_images', default=None, type=int, help='number of images to sample')
    parser.add_argument('--duplicate_data', default=None, type=int, help='duplicate data')


    parser.add_argument('--nesterov', dest='nesterov', default=True, type=bool)
    parser.add_argument('--print_freq', default=10, type=int, metavar='N', help='number of iterations to print the training statistics')
    parser.add_argument('--freeze_base', default=0, type=int, help='number of epochs to train with frozen base')
    parser.add_argument('--update_batchnorm_runningstatistics', default=False, action='store_true', help='update batch norm running statistics')
    ########################################################################################################
    # paf parameter

    parser.add_argument('--stride', default=8, type=int, help='stride of heatmap, vectmap')
    parser.add_argument('--train_scale', default=5, type=int, help='stride of heatmap, vectmap')
    parser.add_argument('--num_pts_between_keypoints', default=10, type=int, help='the number of points between two keypoints ')
    parser.add_argument('--ema', default=1e-3, type=float, help='ema decay constant')
    parser.add_argument('--debug_without_plots', default=False, action='store_true', help='enable debug but dont plot')
    parser.add_argument('--category_name', default='digit0', type=str, help='category name inside of annotation to process')
    parser.add_argument('--model_factor', default=8, type=int, help='image downsampler factor')
    parser.add_argument('--heatmap_threshold', default=0.05, type=float, help='heatmap  threshold')
    parser.add_argument('--pafmap_threshold', default=0.01, type=float, help='pafmap threshold')
    # parser.add_argument('--dataset_type', default='', type=str, help='dataset type')
    parser.add_argument('--dataset_type', default='GenDigit', type=str, help='dataset type')

    ########################################################################################################
    # dataLoader parameter
    parser.add_argument('--num_workers', default=num_workers if not is_debug else 1, type=int, help='number of workers for data loading')

    # thread number for parallelizing cpu-bounding tensor operation
    parser.add_argument('--num_threads', default=num_threads if not is_debug else 1, type=int, help='number of workers for tensor operations')

    ########################################################################################################
    # parameter for  makeImageFolder
    # output directory parameter
    parser.add_argument('--dir_gauge_json', default=dir_gauge_json, help='directory to get gauge inform as json type')
    parser.add_argument('--dir_class_basic', default=dir_class_basic)

    # for make_train_val_from_digit_class
    # parser.add_argument('--dir_class_basic', default=dir_class_basic, help='digit base sample directory to split or for input directory')
    parser.add_argument('--train_ratio', default=0.8, help='train data rate to split the amount of image')


    # parser.add_argument('--dir_class_basic', default=dir_class_basic, help='directory to get gauge inform as json type')
    parser.add_argument('--dir_class_basic_aug', default=dir_class_basic_aug)

    parser.add_argument('--dir_digit_paf', default=dir_digit_paf)
    parser.add_argument('--dir_digit_heat', default=dir_digit_heat)

    #
    parser.add_argument('-o', '--output', default='output.json', help='output file')
    parser.add_argument('--dir_output', default=dir_output, help='output directory')

    ########################################################################################################
    # input parameter for  gen_digit
    parser.add_argument('--aug_level', default=aug_level, help='augmentation level ')
    parser.add_argument('--dir_digit_anno', default=dir_digit_anno, help='digit annotation directory')
    parser.add_argument('--dir_digit_back', default=dir_digit_back, help='digit background directory')
    parser.add_argument('--dir_digit_annoimage', default=dir_digit_annoimage, help='digit annotation and background directory')


    parser.add_argument('--gen_digit_img_load_type', default='partial_load', help='load image and annotation on dram')  # whole_load, partial_load
    parser.add_argument('--fittosize', default=FITTOSIZE, help='annotation file')  # gen_anno, read_anno
    parser.add_argument('--normal', default=0.7, help='normalize to 1. for heatmap location')

    ########################################################################################################
    # parameter for  classifier.



    ########################################################################################################
    # parameter for  pytorch DistributedDataParallel.
    parser.add_argument('--world_size', default=num_threads, type=int,help='전체 프로세스 수 - 마스터가 얼마나 많은 워커들을 기다릴지 알 수 있습니다')
    parser.add_argument('--rank', default=1, type=int,help='각 프로세스의 우선순위 - 워커의 마스터 여부를 확인할 수 있습니다')
    parser.add_argument('--dist_url', default='tcp://127.0.0.1:23456', type=str,help='url used to set up distributed training')
    parser.add_argument('--dist_backend', default=dist_backend, type=str,help='distributed backend')
    parser.add_argument('--seed', default=41, type=int,help='seed for initializing training. ')
    parser.add_argument('--gpu', default=None, type=int,help='GPU id to use.')
    parser.add_argument('--multiprocessing_distributed', action='store_true',default=True,
                        help='Use multi-processing distributed training to launch '
                             'N processes per node, which has N GPUs. This is the '
                             'fastest way to use PyTorch for either single node or '
                             'multi node data parallel training')

    ########################################################################################################
    # parameter for  pickle generation
    pickle_list_cv_heat_paf_path_augname_label_level1 = os.path.join(DIR_DATA, 'data', 'list_cv_heat_paf_path_augname_label_level1.pickle')
    pickle_list_cv_heat_paf_path_augname_label_level2 = os.path.join(DIR_DATA, 'data', 'list_cv_heat_paf_path_augname_label_level2.pickle')
    parser.add_argument('--pickle_list_cv_heat_paf_path_augname_label_level1', default=pickle_list_cv_heat_paf_path_augname_label_level1, help='annotation image pickle file name definition')
    parser.add_argument('--pickle_list_cv_heat_paf_path_augname_label_level2', default=pickle_list_cv_heat_paf_path_augname_label_level2, help='annotation image pickle file name definition')

    ########################################################################################################
    # parameter for  tqdm generation
    parser.add_argument('--verbose', default=verbose,  help='display the progress and message')
    parser.add_argument('--tqdm_desc_head', default=tqdm_desc_head, help='tqdm head message')


    args = parser.parse_args()

    # add args.device
    args.device = torch.device('cpu')
    args.pin_memory = False
    args.cuda = False
    if not args.disable_cuda and torch.cuda.is_available():
        args.device = torch.device('cuda')
        args.pin_memory = True
        args.cuda = True

    # os.makedirs(args.dir_output, exist_ok=True)
    os.makedirs(args.dir_log, exist_ok=True)

    return args
