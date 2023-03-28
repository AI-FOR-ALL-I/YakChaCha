from pill_classifier import *
from get_cli_args import get_cli_args


job = 'resnet152'
if __name__ == '__main__':
    # job = 'hrnet_w64'
    job = 'resnet152'
    args = get_cli_args(job=job, run_phase='train', aug_level=0, dataclass='01')
    args.freeze = True
    print(f'model_path_in_freeze is {args.model_path_in_freeze}')

    end = time.time()
    if args.run_phase == 'train'  :
        args.dataset_train = Dataset_Pill(args, args.json_pill_class_list,  transform=transform_normalize, run_phase='train')
        print(f'train dataset was loaded')

    args.dataset_valid = Dataset_Pill(args, args.json_pill_class_list, transform=transform_normalize, run_phase='test' if args.run_phase == 'test' else 'valid')
    print(f'valid dataset was loaded')


    print(f'dataset loading time is {time.time() - end}')
    pill_classifier(args)
    print('job done')