import codecs, json
import numpy as np
import cv2
import torch
import os
from PIL import Image
from pathlib import Path
from collections import OrderedDict
from torch.utils.data import Dataset
from torchvision import transforms
import torch.optim as optim
from glob import glob
import matplotlib.pyplot as plt
import matplotlib
import logging


def inverse_vgg_preprocess(image):
    means = [0.485, 0.456, 0.406]
    stds = [0.229, 0.224, 0.225]
    image = image.copy().transpose((1, 2, 0))  # 원본 손상 방지.

    for i in range(3):
        image[:, :, i] = image[:, :, i] * stds[i]
        image[:, :, i] = image[:, :, i] + means[i]
    image = image[:, :, ::-1]
    image = image * 255

    image[image > 255.] = 255.
    image[image < 0.] = 0.
    image = image.astype(np.uint8)

    return image

##########################################################################
def save_dict_to_json(dict_save, filejson, mode='w'):
    with codecs.open(filejson, mode, encoding='utf-8') as f:
        json.dump(dict_save, f, ensure_ascii=False, indent=4)


def read_dict_from_json(filejson):
    if not os.path.isfile(filejson) :
        return None
    with codecs.open(filejson, 'r', encoding='utf-8') as f:
        obj = json.load(f)
        return obj

def open_opencv_file(filename):
    img_array = np.fromfile(filename, np.uint8)
    image = cv2.imdecode(img_array, cv2.IMREAD_COLOR)
    return image

def save_opencv_file(image, filename):
    result, encoded_img = cv2.imencode('.jpg', image)
    if result:
        with open(filename, mode='w+b') as f:
            encoded_img.tofile(f)
            return True
    else:
        return False

def show_cvimage(image):
    cv2.imshow('a', image)
    cv2.waitKey()                   # wait을 해야, 이미지가 나온다. PIL은  im.show()으로 바로 나온다.
    cv2.destroyAllWindows()


def show_tensor3(inp, cmap=None):
    """Imshow for Tensor."""
    inp = inp.numpy().transpose((1, 2, 0))
    mean = np.array([0.485, 0.456, 0.406])
    std = np.array([0.229, 0.224, 0.225])
    inp = std * inp + mean
    inp = np.clip(inp, 0, 1)
    plt.imshow(inp, cmap)
    plt.show()
    plt.close()


def save_tensor3(inp, filename):
    """Imshow for Tensor."""
    inp = inp.numpy().transpose((1, 2, 0))
    mean = np.array([0.485, 0.456, 0.406])
    std = np.array([0.229, 0.224, 0.225])
    inp = std * inp + mean
    inp = np.clip(inp, 0, 1)
    matplotlib.image.imsave(filename, inp)



def model_save(model_path, epoch, model, optimizer, rank=0) :
    if rank == 0 :
        torch.save({
            'epoch': epoch,
            'model': model.state_dict(),
            'optimizer': optimizer.state_dict() if optimizer != None else 0 ,
        }, model_path)
        print(f'model was saved to {model_path}')

def model_load(args, model, optimizer, rank=0) :
    epoch_begin = 0
    state_model = None
    state_optimizer = None
    if not os.path.isfile(args.model_path_in):
        print(f"-------------------------------------------------->>>>>>>>>>>>> model_path doesn't exist:{args.model_path_in}")
        return  epoch_begin, None, False      # None check point to indicate a fail

    if args.verbose == True: print(f"model_path will be loaded from:{args.model_path_in}")

    dict_checkpoint = torch.load(args.model_path_in, map_location='cpu')




#     for key in dict_checkpoint.keys():
#         print('key :', key, 'value :', dict_checkpoint[key])




    epoch_begin = dict_checkpoint.get('epoch', -1 ) + 1
    if rank == 0 :
        try:
            state_model = dict_checkpoint.get('model', None )
            if state_model != None :
                if not hasattr(model, 'module') and ('module' in list(state_model.keys())[0] ) :           # model_path은  module 을 포함하고 있다고 가정한다.
                    state_model = OrderedDict([ ( k[7:], v ) if 'module' in k else (k,v ) for k,v in state_model.items()])
                    model.load_state_dict(state_model)
                    print(f'model was loaded from module state')
                elif hasattr(model, 'module') and (not 'module' in list(state_model.keys())[0] ) :
                    state_model = OrderedDict([('module.' + k, v)  for k, v in state_model.items()])
                    model.load_state_dict(state_model)
                    print(f'module.model was loaded from normal state')
                else:
                    model.load_state_dict(state_model)
                    print(f'model was loaded from state')
            else:
                print(f'No model checkpoint in file')

        except Exception as e :
            print(f'Fail to loading model: {e}')
            return epoch_begin, dict_checkpoint, False

        if optimizer != None and args.run_phase == 'train':
            try:
                state_optimizer = dict_checkpoint.get('optimizer', None )
                if state_optimizer != None:
                    optimizer.load_state_dict(state_optimizer)
                    print(f'optimizer was loaded from state')
                else:
                    print(f'No optimizer checkpoint in file')
            except Exception as e :
                print(f'Fail to loading optimizer: {e}')
                return epoch_begin, dict_checkpoint, False
    success = True if state_model != None and state_optimizer != None else False
    return epoch_begin, dict_checkpoint, success


def convert_pil_to_cv2(pil_image):
    pil_image = pil_image.convert('RGB')
    open_cv_image = np.array(pil_image)
    # Convert RGB to BGR
    open_cv_image = open_cv_image[:, :, ::-1].copy()
    return open_cv_image

def convert_cv2_to_pil(cv_image):
    pil_img = Image.fromarray(cv_image)
    return pil_img

def save_img_paf_heat(path, img_temp, paf_temp, heatmap_temp, args ):
    path = Path(path)

    if path.parts[-2].isdigit() :
        dir_paf = os.path.join(args.dir_review_paf_train, path.parts[-2] )
        dir_heat = os.path.join(args.dir_review_heat_train, path.parts[-2])
        dir_img = os.path.join(args.dir_review_img_train, path.parts[-2])
    else:
        dir_paf = args.dir_output
        dir_heat = args.dir_output
        dir_img = args.dir_output

    os.makedirs(dir_paf, exist_ok=True)
    os.makedirs(dir_heat, exist_ok=True)
    os.makedirs(dir_img, exist_ok=True)

    file_base = path.name.split('.')[0]
    filename_img = os.path.join(dir_img, file_base + '_base.jpg')
    filename_paf = os.path.join(dir_paf, file_base + '_paf.jpg')
    filename_heat = os.path.join(dir_heat, file_base + '_heat.jpg')

    save_opencv_file(inverse_vgg_preprocess(img_temp), filename_img)
    save_opencv_file(inverse_vgg_preprocess(paf_temp), filename_paf)
    save_opencv_file(inverse_vgg_preprocess(heatmap_temp), filename_heat)

def open_pil_as_stack_gray_np(filename):
    np_pil = np.array(Image.open(filename).convert('L'))
    np_pil = np.dstack([np_pil,np_pil,np_pil])
    return np_pil

def open_pil_as_stack_color_np(filename):
    np_pil = np.array(Image.open(filename))
    return np_pil

def save_np_pil_file(np_image, filename):
    image_pil = Image.fromarray(np_image)
    image_pil.save(filename)

def accuracy(output, target, topk=(1,)):
    """Computes the precision@k for the specified values of k"""
    with torch.no_grad():
        maxk = max(topk)
        batch_size = target.size(0)

        _, pred = output.topk(maxk, 1, True, True)      #  maxk, dim=1, largest, sorted -> ( value tensor, index longTensor )
        pred = pred.t()
        correct = pred.eq(target.view(1, -1).expand_as(pred))

        res = []
        for k in topk:
            correct_k = correct[:k].reshape(-1).float().sum(0, keepdim=True)
            res.append(correct_k.mul_(100.0 / batch_size))
        return res


def saveimage(sub, dir_digit, basename):
    filename_jpg = os.path.join(dir_digit, basename + '.jpg')
    sub.save(filename_jpg)


def extractDigit_saveto(file_json, file_bmp, list_dir_digit=None):
    dict_bmp_info = read_dict_from_json(file_json)

    digitFractNo = int(dict_bmp_info['digitFractNo'])
    digitAllNo = int(dict_bmp_info['digitAllNo'])
    dataValue = int(dict_bmp_info['dataValue'] * 10 ** digitFractNo)
    digitRect = dict_bmp_info['digitRect']
    str_dataValue = f'{dataValue:0{digitAllNo}}'
    str_igmsGaugeDataId = dict_bmp_info['igmsGaugeDataId']

    if len(str_dataValue) != digitAllNo:
        if len(str_igmsGaugeDataId) == digitAllNo:
            str_dataValue = str_igmsGaugeDataId
        else:
            print(f'{file_json}')
            raise Exception("improper data format")


    list_digitRect = digitRect.split('|')[1:digitAllNo+1]
    list_digitRect = [aa.split(',') for aa in list_digitRect]
    list_digitRect = [[int(a), int(b), int(c), int(d)] for a, b, c, d in list_digitRect]

    img = Image.open(file_bmp)
    if img == None:
        print(f"Can't read a image file :{file_bmp}")
        return

    list_image = []
    for index in range(digitAllNo):
        x, y, width, height = list_digitRect[index]
        sub = img.crop((x, y, x + width, y + height))
        if list_dir_digit != None :
            saveimage(sub, list_dir_digit[int(str_dataValue[index])], os.path.basename(file_json).split('.')[0] + f'_{index}{str_dataValue[index]}')
        else:
            list_image.append(sub.convert('RGB'))

    if list_dir_digit == None :
        return list_image, [int(aa) for aa in str_dataValue], dict_bmp_info

def get_Image_Value_List_from_json(file_json):
    list_image, list_value, dict_json_info = extractDigit_saveto(file_json, os.path.splitext(file_json)[0] + '.bmp')
    list_cv_label_path = [(list_image[i], list_value[i], file_json) for i in range(len(list_image))]
    return list_cv_label_path

transform_normalize = transforms.Compose([
                                 transforms.ToTensor(),
                                 transforms.Normalize(mean=[0.485, 0.456, 0.406],
                                                      std=[0.229, 0.224, 0.225])
                             ])

transform_classifier = transforms.Compose([transforms.Resize((224, 224))
                                         , transforms.ToTensor()
                                         , transforms.Normalize([0.485, 0.456, 0.406], [0.229, 0.224, 0.225])
                                      ])

transfrom_paf = transforms.Compose([transforms.Resize((368, 368))
                                         , transforms.ToTensor()
                                         , transforms.Normalize([0.485, 0.456, 0.406], [0.229, 0.224, 0.225])
                                      ])

class Dataset_valid(Dataset):
    def __init__(self, file_json, transform):
        if os.path.isfile(file_json) and file_json.split('.')[-1] == 'json':
            self.list_cv_label_path = get_Image_Value_List_from_json(file_json)
        elif os.path.isdir(file_json):
            self.list_cv_label_path = [(Image.open(aa).convert("RGB"), int(str(Path(aa).parts[-2])), aa) for aa in glob(file_json + r'/**/*.jpg')]
        self.transform = transform
        self.file_json = file_json

    def __len__(self):
        # return size of dataset
        return len(self.list_cv_label_path)

    def __getitem__(self, idx):
        image, label, path = self.list_cv_label_path[idx]
        if self.transform != None:
            image = self.transform(image)
        return image, (label, path)

def get_optimizer(args, model):
    optimizer = None
    if args.optimizer == 'sgd':
        optimizer = optim.SGD(
            filter(lambda p: p.requires_grad, model.parameters()),
            lr=args.lr,
            momentum=args.momentum,
            weight_decay=args.wd,
            nesterov=args.nesterov
        )
        if args.verbose == True: print(f'optimizer was selected as type:sgd')
    elif args.optimizer == 'adam':
        optimizer = optim.Adam( filter(lambda p: p.requires_grad, model.parameters()), lr=args.lr)
        if args.verbose == True: print(f'optimizer was selected as type:adam')
    elif args.optimizer == 'rmsprop':
        optimizer = optim.RMSprop(
            filter(lambda p: p.requires_grad, model.parameters()),
            lr=args.lr,
            momentum=args.momentum,
            weight_decay=args.wd,
        )
        if args.verbose == True: print(f'optimizer was selected as type:rmsprop')
    return optimizer

def adjust_learning_rate(args, optimizer, epoch):
    assert hasattr(args, 'lr_schedule'), "args doesn't have lr schedule"
    assert hasattr(args, 'lr_gamma'), "args doesn't have lr gamma"
    assert hasattr(args, 'lr'), "args doesn't have lr"

    if epoch in args.lr_schedule:
        args.lr *= args.lr_gamma
        for param_group in optimizer.param_groups:
            param_group['lr'] = args.lr



class AverageMeter(object):
    """  val을 계속 누적하고,  평균을 구함."""

    def __init__(self):
        self.reset()

    def reset(self):
        self.sum = 0
        self.count = 0

    def update(self, val, n=1):
        self.sum += val * n
        self.count += n

    @property
    def avg(self):
        return self.sum / self.count

    @property
    def val(self):
        return self.sum

def create_logging(file_log):
    path_file_log = Path(file_log)
    path_dir_log = path_file_log.parent
    path_dir_log.mkdir(exist_ok=True)

    logger = logging.getLogger()
    logger.setLevel(logging.DEBUG)

    formatter_stream = logging.Formatter(u'%(message)s')
    streamingHandler = logging.StreamHandler()
    streamingHandler.setFormatter(formatter_stream)

    formatter_file = logging.Formatter(u'%(asctime)s [%(levelname)8s] %(message)s')
    file_handler = logging.FileHandler(file_log)
    file_handler.setFormatter(formatter_file)

    logger.addHandler(streamingHandler)
    logger.addHandler(file_handler)

    return logger

