import cv2

from get_cli_args import get_cli_args
from pathlib import Path
import utils
import numpy

def estimate_sharpness(image: numpy.array, threshold: int = 100):
    if image.ndim == 3:
        image = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)

    blur_map = cv2.Laplacian(image, cv2.CV_64F)
    score = numpy.var(blur_map)
    return score

def make_label_sharpness(args):
    pathdir_dest = Path(args.dir_pill_class_base)
    # dict_pill_prescription_type = utils.read_dict_from_json(args.json_pill_prescription_type)['pill_prescription_type']

    # list_pills_pres_sharp_score = []
    # list_pills_otc_sharp_score = []
    list_pills_sharp_score = []
    count = 0
    for pathdir_pill_class in pathdir_dest.iterdir():
        if not pathdir_pill_class.is_dir() :
            continue
        print(f'{count}, {pathdir_pill_class} is being estimated')
        count += 1
        list_pill_class_shape_score = []
        for  pathfile_pill_png in pathdir_pill_class.iterdir():
            if pathfile_pill_png.suffix == '.json':
                continue
            score = estimate_sharpness(utils.open_opencv_file(str(pathfile_pill_png)))
            list_pill_class_shape_score.append(score)

        score_min = min(list_pill_class_shape_score)
        score_max = max(list_pill_class_shape_score)
        score_mean = sum(list_pill_class_shape_score)/len(list_pill_class_shape_score)
        # if dict_pill_prescription_type[pathdir_pill_class.stem] == 'PRES':
        #     list_pills_pres_sharp_score.append([str(pathdir_pill_class.stem), score_mean, score_min,score_max])
        # elif dict_pill_prescription_type[pathdir_pill_class.stem] == 'OTC':
        #     list_pills_otc_sharp_score.append([str(pathdir_pill_class.stem), score_mean, score_min,score_max])
        list_pills_sharp_score.append([str(pathdir_pill_class.stem), score_mean, score_min,score_max])

    # list_pills_pres_sharp_score = sorted(list_pills_pres_sharp_score, key=lambda a: a[2], reverse=True)         # sharp min 기준으로 정렬.
    # list_pills_otc_sharp_score = sorted(list_pills_otc_sharp_score, key=lambda a: a[2], reverse=True)           # sharp min 기준으로 정렬.
    list_pills_sharp_score = sorted(list_pills_sharp_score, key=lambda a: a[2], reverse=True)           # sharp min 기준으로 정렬.
    # list_pills_label_path_sharp_score = [ [label, pathname, score_mean, score_min, score_max] for label, ( pathname, score_mean, score_min, score_max ) in enumerate(list_pills_pres_sharp_score) if label < 600]
    # list_pills_label_path_sharp_score += [[label+600, pathname, score_mean, score_min, score_max] for label, (pathname, score_mean, score_min, score_max) in enumerate(list_pills_otc_sharp_score) if label < 400]
    list_pills_label_path_sharp_score = [ [label, pathname, score_mean, score_min, score_max] for label, ( pathname, score_mean, score_min, score_max ) in enumerate(list_pills_sharp_score) if label < 600]

    dict_temp = { 'pill_label_path_sharp_score':list_pills_label_path_sharp_score}

    utils.save_dict_to_json(dict_temp, args.json_pill_label_path_sharp_score)

def get_dict_label_pillid(args):
    dict_temp = utils.read_dict_from_json(args.json_pill_label_path_sharp_score)
    list_pills_label_path_sharp_score = dict_temp['pill_label_path_sharp_score']

    dict_label_pillid = {}
    for idx , (label, pillid, score_mean, score_min, score_max) in enumerate(list_pills_label_path_sharp_score) :
        if idx >= args.num_classes:
            break
        # print(f'{label},{pillid},{score_mean},{score_min},{score_max}')
        dict_label_pillid.update({label: pillid})

    return dict_label_pillid


def get_dict_pillid_label(args):
    dict_temp = utils.read_dict_from_json(args.json_pill_label_path_sharp_score)
    list_pills_label_path_sharp_score = dict_temp['pill_label_path_sharp_score']

    dict_label_pillid = {}
    for idx, (label, pillid, score_mean, score_min, score_max) in enumerate(list_pills_label_path_sharp_score):
        if idx >= args.num_classes:
            break
        dict_label_pillid.update({pillid:label})

    return dict_label_pillid




if __name__ == '__main__':

    # job = 'hrnet_w64'
    job = 'resnet152'
    args = get_cli_args(job=job, run_phase='train', aug_level=1, dataclass='0')
    args.logger = utils.create_logging(args.file_log)
    make_label_sharpness(args)
    # get_dict_pillid_label(args)
    # dict_label_pillid = get_dict_label_pillid(args)
    print('done')
