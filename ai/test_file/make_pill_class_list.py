import shutil

from get_cli_args import get_cli_args
import utils
from pathlib import Path
import random
import os

def get_pill_info_from_pillfile(path_png):
    pill_basename, pill_status, pill_back, pill_front, pill_light, pill_lati, pill_longi, pill_dist = path_png.stem.split('_')
    pill_status, pill_back, pill_front, pill_light, pill_lati, pill_longi, pill_dist = int(pill_status), int(pill_back), int(pill_front), int(pill_light), int(pill_lati), int(pill_longi), int(pill_dist)
    return pill_basename, pill_status, pill_back, pill_front, pill_light, pill_lati, pill_longi, pill_dist

def get_pillid_from_pillfile(file_png):
    try :
        pill_basename, pill_status, pill_back, pill_front, pill_light, pill_lati, pill_longi, pill_dist = Path(file_png).stem.split('_')
    except:
        # 상위 dir의  name이  pill id가 된다.
        path_file = Path(file_png)
        pill_basename = path_file.parts[-2]
    return pill_basename

def make_pill_class_list(args):
    '''
    json_pill_sharpness 파일으로 부터, dataset을 만든다.
    class 1 :  카메라 위도, 90, 75
    class 2 : 카메라 위도 70, 65
    :param args:
    :return:
    train set : 90%
    valid set : 10%
    test set : 10%
    '''

    pill_class0 = []
    pill_class1 = []
    dict_temp = utils.read_dict_from_json(args.json_pill_label_path_sharp_score)
    list_pills_label_pillid_sharp_score = dict_temp['pill_label_path_sharp_score']
    for label, pillid, score_mean, score_min, score_max in list_pills_label_pillid_sharp_score:
        if label >= args.num_classes:
            continue
        print(f'reading sharp score.  label:{label}')
        pillid = Path(os.path.join(args.dir_pill_class_base, pillid))
        for file_png in pillid.iterdir():
            if file_png.suffix != '.png':
                continue

            pill_basename, pill_status, pill_back, pill_front, pill_light, pill_lati, pill_longi, pill_dist = get_pill_info_from_pillfile(file_png)

            if pill_lati in args.pill_dataset_class0:
                pill_class0.append(str(file_png))
            elif pill_lati in args.pill_dataset_class1:
                pill_class1.append(str(file_png))
            else:
                pass

    list_index_class0 = list(range(len(pill_class0)))
    len_train = int(round(args.pill_dataset_train_rate * len(list_index_class0)))
    list_index_class0_train = random.sample(list_index_class0, len_train)
    list_index_class0_valid = list(set(list_index_class0) - set(list_index_class0_train))
    list_index_class0_test = random.sample(list_index_class0_valid, int(round(len(list_index_class0_valid) * (args.pill_dataset_test_rate / (args.pill_dataset_test_rate + args.pill_dataset_valid_rate)))))
    list_index_class0_valid = list(set(list_index_class0_valid) - set(list_index_class0_test))

    list_index_class1 = list(range(len(pill_class1)))
    len_train = int(round(args.pill_dataset_train_rate * len(list_index_class1)))
    list_index_class1_train = random.sample(list_index_class1, len_train)
    list_index_class1_valid = list(set(list_index_class1) - set(list_index_class1_train))
    list_index_class1_test = random.sample(list_index_class1_valid, int(round(len(list_index_class1_valid) * (args.pill_dataset_test_rate / (args.pill_dataset_test_rate + args.pill_dataset_valid_rate)))))
    list_index_class1_valid = list(set(list_index_class1_valid) - set(list_index_class1_test))

    list_pngfile_class0_train = [pill_class0[index] for index in list_index_class0_train]
    list_pngfile_class0_valid = [pill_class0[index] for index in list_index_class0_valid]
    list_pngfile_class0_test = [pill_class0[index] for index in list_index_class0_test]

    list_pngfile_class1_train = [pill_class1[index] for index in list_index_class1_train]
    list_pngfile_class1_valid = [pill_class1[index] for index in list_index_class1_valid]
    list_pngfile_class1_test = [pill_class1[index] for index in list_index_class1_test]

    print(f'pngfile_class0_train:{len(list_pngfile_class0_train)}')
    print(f'pngfile_class0_valid:{len(list_pngfile_class0_valid)}')
    print(f'pngfile_class0_test:{len(list_pngfile_class0_test)}')

    print(f'pngfile_class1_train:{len(list_pngfile_class1_train)}')
    print(f'pngfile_class1_valid:{len(list_pngfile_class1_valid)}')
    print(f'pngfile_class1_test:{len(list_pngfile_class1_test)}')

    dict_temp = {'pngfile_class0_train': list_pngfile_class0_train, 'pngfile_class0_valid': list_pngfile_class0_valid, 'pngfile_class0_test': list_pngfile_class0_test, 'pngfile_class1_train': list_pngfile_class1_train, 'pngfile_class1_valid': list_pngfile_class1_valid, 'pngfile_class1_test': list_pngfile_class1_test, }

    utils.save_dict_to_json(dict_temp, args.json_pill_class_list)

def rename_non_candidate_to_s_id(args):
    # 후보가 아닌 알약 directory을  다른 이름(K head)으로 변경한다.
    dict_temp = utils.read_dict_from_json(args.json_pill_label_path_sharp_score)
    list_pills_label_pillid_sharp_score = dict_temp['pill_label_path_sharp_score']
    list_candidate_ids = [ pillid for label, pillid, score_mean, score_min, score_max in list_pills_label_pillid_sharp_score ]

    path_pill_base = Path(args.dir_pill_class_base )
    list_pill_all_id = []
    for pill_dir in path_pill_base.iterdir():
        if not pill_dir.is_dir() :
            continue
        list_pill_all_id.append(pill_dir.stem)

    list_non_candidate_pillid = list( set(list_pill_all_id) - set(list_candidate_ids))

    for pillid in list_non_candidate_pillid :
        new_id = pillid.replace('K', 'S')
        path_old = os.path.join(args.dir_pill_class_base, pillid)
        path_new = os.path.join(args.dir_pill_class_base, new_id)
        shutil.move(path_old, path_new)


if __name__ == '__main__':

    # job = 'hrnet_w64'
    job = 'resnet152'
    args = get_cli_args(job=job, run_phase='train', aug_level=1, dataclass='0')
    args.logger = utils.create_logging(args.file_log)
    make_pill_class_list(args)
    rename_non_candidate_to_s_id(args)
    print('job done')
