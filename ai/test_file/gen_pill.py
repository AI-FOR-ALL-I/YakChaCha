import numpy as np
import cv2
from imgaug import augmenters as iaa
from pathlib import Path
import utils
import make_label_sharpness
from make_pill_class_list import get_pillid_from_pillfile
from PIL import Image

# https://github.com/aleju/imgaug

list_level_aug_geo = [
    [0, iaa.Identity()],
]

list_level_aug_geo_scale = [
    [0, iaa.Identity()],
    [1, iaa.Affine(scale=0.85)],
    [2, iaa.Affine(scale=0.80)],
    [3, iaa.Affine(scale=0.75)],
    [3, iaa.Affine(scale=0.70)],

]

list_level_aug_geo_rotate = [
    [0,iaa.Identity()],
]

list_level_aug_non_geo = [
    [0,iaa.Identity()],
    [1,iaa.GaussianBlur(sigma=1.0)],
    [2,iaa.Dropout(p=0.05)],
    [2,iaa.CoarseDropout(0.02, size_percent=0.5)],
    [2,iaa.SaltAndPepper(0.1)],
    [2,iaa.JpegCompression(compression=10)],
    [3,iaa.ChangeColorTemperature(1000)],
    [3,iaa.ChangeColorTemperature(4000)],
    [3,iaa.Snowflakes(flake_size=0.1, speed=0.01)],
    [3,iaa.GammaContrast(2.0)],
]

def rescaleToFit(np_image, np_point, fit_x, fit_y, scale_limit = 0.8):      #  scale_limit is for image rotation with nppoint.
    np_image = np_image.copy()
    h, w, c = np_image.shape
    # show_cvimage(np_image)
    scale = fit_x / w       # 먼저 x scale 을 정하고,
    if scale * h > fit_y :  # scale이 h 에는  over height.
        scale =  fit_y /  h # y scale으로 정한다.

    scale = scale * scale_limit
    np_image = cv2.resize(np_image, (int(round(w * scale)), int(round(h * scale)) ))
    x_scale = np_image.shape[1] / w
    y_scale = np_image.shape[0] / h

    np_images_back = np.zeros((fit_y, fit_x, c), dtype=np.uint8)
    x_offset = (fit_x - np_image.shape[1]) // 2
    y_offset = (fit_y - np_image.shape[0]) // 2

    np_images_back[y_offset:y_offset + np_image.shape[0], x_offset:x_offset+np_image.shape[1], : ] = np_image


    if len(np_point) > 0:
        np_point *= (x_scale, y_scale)

        np_point[np_point < 0 ] += -1000
        np_point += [x_offset, y_offset ]
        np_point[np_point < 0 ] = -1

    # draw_limbs_on_image(np_images_back,np_point, list_limb_digit0, (0, 0, 255), 2 , False )
    # show_cvimage(np_images_back)

    return np_images_back, np_point


list_aug_geo = []
list_aug_geo_scale=[]
list_aug_geo_rotate = []
list_aug_non_geo = []

class Gen_Digit():
    def __init__(self,args, dir_dataset,run_phase):
        print(f'dataset dir is {dir_dataset}')

        self.build_list_gen_based_on_level(args)
        self.args = self.gen_pill_ready(args, dir_dataset, run_phase)

    def build_list_gen_based_on_level(self, args):
        global list_aug_geo, list_aug_geo_scale, list_aug_geo_rotate, list_aug_non_geo

        print(f'run_phase is {args.run_phase}, aug_level is {args.aug_level}')

        for i, (level, aug) in enumerate( list_level_aug_geo):
            aug.name = f'g{i}'
        for i, (level, aug) in enumerate( list_level_aug_geo_scale):
            aug.name = f's{i}'
        for i, (level, aug) in enumerate( list_level_aug_geo_rotate):
            aug.name = f'r{i}'
        for i, (level, aug) in enumerate( list_level_aug_non_geo):
            aug.name = f'n{i}'

        if args.run_phase == 'train' :
            list_aug_geo = [ aug for level, aug in list_level_aug_geo if level <= args.aug_level]
            list_aug_geo_scale = [aug for level, aug in list_level_aug_geo_scale if level <= args.aug_level]
            list_aug_geo_rotate = [aug for level, aug in list_level_aug_geo_rotate if level <= args.aug_level]
            list_aug_non_geo = [aug for level, aug in list_level_aug_non_geo if level <= args.aug_level]
        else:
            list_aug_geo = [iaa.Identity()]
            list_aug_geo_scale = [iaa.Identity()]
            list_aug_geo_rotate = [iaa.Identity()]
            list_aug_non_geo = [iaa.Identity()]

    def gen_pill_ready(self, args, dir_dataset, run_phase):
        global list_aug_geo, list_aug_geo_scale, list_aug_geo_rotate, list_aug_non_geo
        print(f'gen_type is {args.gen_type}, loading data ...')

        path_dir_json = Path(dir_dataset)
        if path_dir_json.is_dir() :
            print(f'Gen :reading directory was not implemented')
            self.len_total = 0

        elif path_dir_json.is_file() and path_dir_json.suffix == '.json' and args.gen_type == 'read_only_image':

            dict_temp = utils.read_dict_from_json(str(path_dir_json))
            self.list_label_path = []
            if args.gen_dataclass_sel in [ 'dataclass0', 'dataclass01'] :
                if run_phase == 'train' :
                    self.list_label_path += dict_temp.get('pngfile_class0_train', [])
                    print(f'label_path was loaded from   <<< pngfile_class0_train >>>')
                elif run_phase == 'valid' :
                    self.list_label_path += dict_temp.get('pngfile_class0_valid', [])
                    print(f'label_path was loaded from   <<< pngfile_class0_valid >>>')
                else:
                    self.list_label_path += dict_temp.get('pngfile_class0_test', [])
                    print(f'label_path was loaded from   <<< pngfile_class0_test >>>')

            if args.gen_dataclass_sel in [ 'dataclass1', 'dataclass01'] :
                if run_phase == 'train' :
                    self.list_label_path += dict_temp.get('pngfile_class1_train', [])
                    print(f'label_path was loaded from   <<< pngfile_class1_train >>>')
                elif run_phase == 'valid' :
                    self.list_label_path += dict_temp.get('pngfile_class1_valid', [])
                    print(f'label_path was loaded from   <<< pngfile_class1_valid >>>')
                else:
                    self.list_label_path += dict_temp.get('pngfile_class1_test',[])
                    print(f'label_path was loaded from   <<< pngfile_class1_test >>>')

            dict_pillid_label = make_label_sharpness.get_dict_pillid_label(args)
            self.list_label_path = [(dict_pillid_label[get_pillid_from_pillfile(pngfile)], pngfile) for pngfile in self.list_label_path]

            self.list_aug_geo = list_aug_geo
            self.list_aug_geo_scale = list_aug_geo_scale
            self.list_aug_geo_rotate = list_aug_geo_rotate
            self.list_aug_non_geo = list_aug_non_geo

            self.len_list_aug_geo = len(self.list_aug_geo)
            self.len_list_aug_geo_scale = len(self.list_aug_geo_scale)
            self.len_list_aug_geo_rotate = len(self.list_aug_geo_rotate)
            self.len_list_aug_non_geo = len(self.list_aug_non_geo)
            self.len_list_label_path = len(self.list_label_path)

            self.len_total = self.len_list_aug_geo * self.len_list_aug_geo_scale * self.len_list_aug_geo_rotate * self.len_list_aug_non_geo * self.len_list_label_path
            self.div_aug_geo = self.len_list_aug_geo_scale * self.len_list_aug_geo_rotate * self.len_list_aug_non_geo * self.len_list_label_path
            self.div_aug_geo_scale = self.len_list_aug_geo_rotate * self.len_list_aug_non_geo * self.len_list_label_path
            self.div_aug_geo_rotate = self.len_list_aug_non_geo * self.len_list_label_path
            self.div_aug_non_geo = self.len_list_label_path

        print(f"data loading done.  dataset'length is {self.len_total}")
        return args


    def generate_digits_by_index(self,args, index ) :
        if args.gen_type == 'read_only_image' :

            ind = index // self.div_aug_geo
            mod = index % self.div_aug_geo

            aug_geo = self.list_aug_geo[ind]

            ind = mod // self.div_aug_geo_scale
            mod = mod % self.div_aug_geo_scale

            aug_geo_scale = self.list_aug_geo_scale[ind]

            ind = mod // self.div_aug_geo_rotate
            mod = mod % self.div_aug_geo_rotate

            aug_geo_rotate = self.list_aug_geo_rotate[ind]

            ind = mod // self.div_aug_non_geo
            mod = mod % self.div_aug_non_geo

            aug_non_geo = self.list_aug_non_geo[ind]
            label, path_img = self.list_label_path[mod]
            np_image = np.array(Image.open(path_img))

            # np_image= aug_geo(image=np_image)
            # np_image= aug_geo_scale(image=np_image)
            # np_image= aug_geo_rotate(image=np_image)
            # np_image= aug_non_geo(image=np_image)

            iaaaug = iaa.Sequential([aug_geo, aug_geo_scale, aug_geo_rotate, aug_non_geo])
            np_image = iaaaug(image=np_image)

            aug_name = aug_geo.name + aug_geo_scale.name + aug_geo_rotate.name + aug_non_geo.name

            return np_image, label, path_img, aug_name

if __name__ == '__main__' :
    print(f'done')