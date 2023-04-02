from .pill_classifier import *
from .get_cli_args import get_cli_args
from .make_pill_itemseq_dict import search_itemseq_by_pillid as search

class Dataset_PIL(Dataset):
    def __init__(self, args, pil_image, transform=None, target_transform=None, run_phase='train'):
        self.args = args
        self.pil_image = pil_image
        self.transform = transform
        self.target_transform = target_transform
        self.run_phase = run_phase

    def __len__(self):
        return 1

    def __getitem__(self, idx):
        image = self.pil_image.convert('RGB')
        label = 0
        path_img = ''
        aug_name = ''
        if self.transform is not None:
            image = self.transform(image)

        if self.target_transform is not None:
            label = self.target_transform(label)
        if self.run_phase == 'valid' or self.run_phase == 'test':
            return image, label, path_img, aug_name
        else:
            return image, label


def run_search_model(pil_image):
    job = 'resnet152'
    args = get_cli_args(job=job, run_phase='test', aug_level=0, dataclass='01')

    print(f'model_path_in is {args.model_path_in}')

    # dir_testimage = r'./proj_pill/proj_pill/dir_testimage'

    args.dataset_valid = Dataset_PIL(args, pil_image, transform=transform_normalize, run_phase='test' if args.run_phase == 'test' else 'valid')
    args.batch_size = len(args.dataset_valid)
    args.verbose = False
    print(f'valid dataset was loaded')

    pill_classifier(args)

    results = args.list_results
    results_sim = results[0].view(-1).tolist()[:5]
    results_idx = results[1].view(-1).tolist()[:5]

    result = {
        'item_seq': [str(search(args.dict_idx_itemid[results_idx[rk]], args.json_pill_itemseq_dict)[0]) for rk in range(5)]
    }
    
    print('job done')
    return result