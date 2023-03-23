from pill_classifier import *
from get_cli_args import get_cli_args
from pathlib import Path
from PIL import Image
import os

class Dataset_Dir(Dataset):
    def __init__(self, args, dir_dataset, transform=None, target_transform=None, run_phase='train'):
        self.args = args
        self.dir_dataset = dir_dataset
        self.transform = transform
        self.target_transform = target_transform

        self.list_images = [ png.name  for png in Path(dir_dataset).iterdir() if png.suffix == '.png']
        self.run_phase = run_phase

    def __len__(self):
        return len(self.list_images)

    def __getitem__(self, idx):
        image = Image.open(os.path.join(self.dir_dataset, self.list_images[idx])).convert('RGB')
        label = 0
        path_img = self.list_images[idx]
        aug_name = ""

        if self.transform is not None:
            image = self.transform(image)

        if self.target_transform is not None:
            label = self.target_transform(label)
        if self.run_phase == 'valid' or self.run_phase == 'test':
            return image, label, path_img, aug_name
        else:
            return image, label


job = 'resnet152'
if __name__ == '__main__':
    # job = 'hrnet_w64'
    job = 'resnet152'
    file_num = input('Enter file number : ', )
    file_name = f'file_{file_num}'
    args = get_cli_args(job=job, run_phase='test', aug_level=0, dataclass='01', file_number=file_num)

    print(f'model_path_in is {args.model_path_in}')

    dir_testimage = r'dir_testimage'

    args.dataset_valid = Dataset_Dir(args, dir_testimage, transform=transform_normalize, run_phase='test' if args.run_phase == 'test' else 'valid')
    args.batch_size = len(args.dataset_valid)
    args.verbose = False
    print(f'valid dataset was loaded')
    
    pill_classifier(args)

#     print(args.path_img)
    print(args.list_preds)
    print('job done')