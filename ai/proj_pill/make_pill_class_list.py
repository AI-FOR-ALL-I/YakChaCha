import shutil

from get_cli_args import get_cli_args
import utils
from pathlib import Path
import random
import os


'''
path_png를 입력으로 받음
사진의 메타데이터를 반환하는 함수로 추정.
path_png가 /path/to/myfile.txt 인 경우 stem으로 myfile을 받을 수 있음.
즉 해당 함수에서 입력은 다음과 같은 형식의 파일 경로일 것을 추정
(pill_basename)_(pill_status)_(pill_back)_(pill_front)_(pill_light)_(pill_lati)_(pill_longi)_(pill_dist).png
따라서 stem으로 .png를 떼고 split('_')으로 데이터를 분리, int로 정수형태로 변환, 마지막으로 반환하는 구조
반환하는 데이터 목록
pill_basename, pill_status, pill_back, pill_front, pill_light, pill_lati, pill_longi, pill_dist
'''
def get_pill_info_from_pillfile(path_png):
    pill_basename, pill_status, pill_back, pill_front, pill_light, pill_lati, pill_longi, pill_dist = path_png.stem.split('_')
    pill_status, pill_back, pill_front, pill_light, pill_lati, pill_longi, pill_dist = int(pill_status), int(pill_back), int(pill_front), int(pill_light), int(pill_lati), int(pill_longi), int(pill_dist)
    return pill_basename, pill_status, pill_back, pill_front, pill_light, pill_lati, pill_longi, pill_dist




'''
해당 함수는 gen_pill.py에서 사용됨
위의 get_pill_info_from_pillfile와 비슷한 역할을 하는듯?
try : 경로에 stem, split으로 데이터 분리하여 저장. pill_basename만 반환
except : try에서 오류가 발생하는 경우(아마 _로 split 했을 때 형식이 맞지 않는 경우일듯) parts를 사용
path_file이 /path/to/myfile.txt 인 경우 parts로 ('', 'path', 'to', 'myfile.txt')를 받을 수 있음
따라서 parts[-2]를 통해 현재 파일의 상위 디렉토리 이름을 pill_basename에 저장하여 반환


"/home/ubuntu/proj/proj_pill/pill_data/pill_data_croped/K-007645/K-007645_0_2_1_1_90_300_200.png"
이렇게 들어오면?
return K-007645
'''
def get_pillid_from_pillfile(file_png):
    try :
        pill_basename, pill_status, pill_back, pill_front, pill_light, pill_lati, pill_longi, pill_dist = Path(file_png).stem.split('_')
    except:
        # 상위 dir의  name이  pill id가 된다.
        path_file = Path(file_png)
        pill_basename = path_file.parts[-2]
    return pill_basename





def make_pill_class_list(args, file_name):
    '''
    json_pill_sharpness 파일으로 부터, dataset을 만든다.
    class 0 :  카메라 위도, 90, 75
    class 1 : 카메라 위도 70, 60
    :param args:
    :return:
    train set : 80%
    valid set : 10%
    test set : 10%
    '''

    pill_class0 = []
    pill_class1 = []
    
    
    '''
    json_pill_label_path_sharp_score 의 json 파일을 dict 으로 변환 (utils의 read_dict_from_json으로)
    json 파일 안에서는 다음과 같은 형식의 데이터를 갖고 있음
        [
            995,
            "K-015236",
            13.123586364601014,
            4.8197076837999635,
            33.66023879108803
        ],
    for문으로 list_pills_label_pillid_sharp_score을 순회하면
    위에서 차례대로 label, pillid, score_mean, score_min, score_max 에 저장    
    '''
    dict_temp = utils.read_dict_from_json(args.json_pill_label_path_sharp_score)
    list_pills_label_pillid_sharp_score = dict_temp['pill_label_path_sharp_score']
    for label, pillid, score_mean, score_min, score_max in list_pills_label_pillid_sharp_score:
        
        '''
        첫번째 for문 내부
        label은 약 번호 1~1000에 해당하는 값인데 
        입력으로 들어오는 args에서 args.num_classes 보다 크거나 같으면 continue
        작은 경우에만 나머지 실행.
        reading sharp score. label:(약번호)        출력
        다음 args.dir_pill_class_base에 pillid를 합쳐주어 경로로 pillid에 저장한다
        다음 for 문에서는 앞서 저장한 pillid 디렉토리의 파일들을 순회한다.
        '''
        # 이부분은 생략. 1000개 넘게 사용할 예정이기 때문.
        # if label >= args.num_classes:
        #     continue
        print(f'reading sharp score.  label:{label}')
        pillid = Path(os.path.join(args.dir_pill_class_base, file_name, pillid))
        # 현재 pill_data_croped에 없는 pillid가 json파일에 있기 때문에 처리 필요.
        print(pillid, pillid.exists())
        if pillid.exists() == False:
            continue


        for file_png in pillid.iterdir():
            
            '''
            두번째 for문 내부
            pillid 디렉토리 내부의 파일들을 순회하는 for문, 해당 파일을 file_png에 저장
            file_png의 확장자 명이 .png가 아닌경우 continue
            .png가 맞으면 위에서 정의된 get_pill_info_from_pillfile을 통해 데이터를 각각의 변수에 저장한다.
            여기서 실제로 사용하는 값은 pill_lati 한개.
            여기서 latitude는 물체(약)을 중심으로 한 카메라 위도를 말하는 듯.
            60, 70, 75, 90 이 있는것 같고 90의 경우 약 위에서 수직으로 찍은 사진. 60은 90 보다 30도 내려온 사진으로 보면 될 듯.
            if문과 elif 문에서는 pill_lati가 args.pill_dataset_class0/1에 있는지 확인. 확인 후 pill_class0/1에 file_png(사진파일 경로?) append
            '''
            
            if file_png.suffix != '.png':
                continue

            pill_basename, pill_status, pill_back, pill_front, pill_light, pill_lati, pill_longi, pill_dist = get_pill_info_from_pillfile(file_png)

            if pill_lati in args.pill_dataset_class0:
                pill_class0.append(str(file_png))
            elif pill_lati in args.pill_dataset_class1:
                pill_class1.append(str(file_png))
            else:
                pass
    
    '''
    위에까지 해서 pill_class0와 pill_class1에 다 넣어줌
    
    다음은 저장한 pill_class에 따라서 진행.
    (위에서 train 0.9, valid 0.1, test 0.1이라고 했는데 맞는지는 모르겠음.. 0.8, 0.1, 0.1이 더 자연스러울듯)
    args.pill_dataset_train_rate * pill_class0 length 둘이 곱한 값이 len_train (여기선 아마도 0.9??)
    train : list_index_class0에서 len_train 갯수 만큼 랜덤으로 뽑음
    test : 전체 - train 에서 test와 valid 비율에 맞는 갯수만큼 랜덤으로 뽑음
    valid : 전체 - train - test 
    
    class0 와 class1 모두 진행 후 인덱스에 해당하는 파일명으로 list_pngfile_class0_train, valid, test 리스트 생성
    각각 len 얼마 되는지 출력,
    dict_temp에 'pngfile_class0_train' : list_pngfile_class0_train 형식으로 딕셔너리 생성
    utils의 save_dict_to_json 통해 args.json_pill_class_list 경로에 json파일 형식으로 저장/덮어쓰기 실행
    '''
    
    
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
    save_dir = Path(os.path.join(args.dir_pill_class_base, file_name, pillid))
    utils.save_dict_to_json(dict_temp, args.json_pill_class_list)










def rename_non_candidate_to_s_id(args):
    # 후보가 아닌 알약 directory을  다른 이름(K head)으로 변경한다.
    
    '''
    위와 마찬가지로 json파일 을 dict 형태로 호출
    내부의 list 저장
    pillid만 모아서 list_candidate_ids에 저장
    '''
    
    dict_temp = utils.read_dict_from_json(args.json_pill_label_path_sharp_score)
    list_pills_label_pillid_sharp_score = dict_temp['pill_label_path_sharp_score']
    list_candidate_ids = [ pillid for label, pillid, score_mean, score_min, score_max in list_pills_label_pillid_sharp_score ]

    
    '''
    path_pill_base는 args.dir_pill_class_base로 약 사진폴더들이 모여 있는 디렉토리
    iterdir로 순회 할때 약 id에 해당하는 파일 들을 순회
    for문에서 pill_dir 이 약 id 이름의 폴더(디렉토리)
    is_dir() 이 False면 continue
    디렉토리가 맞으면 pill_dir.stem으로 디렉토리 이름(약 id)만 잘라서 list_pill_all_id 에 저장
    '''
    path_pill_base = Path(args.dir_pill_class_base )
    list_pill_all_id = []
    for pill_dir in path_pill_base.iterdir():
        if not pill_dir.is_dir() :
            continue
        list_pill_all_id.append(pill_dir.stem)


    '''
    list_pill_all_id는 현재 경로에 있는 디렉토리의 약 id를 모두 모은 list
    list_candidate_ids는 json 파일에 존재하는 pillid를 모두 모은것
    list_non_candidate_pillid는 디렉토리에는 있지만 json파일에는 없는 약id
    '''
    list_non_candidate_pillid = list( set(list_pill_all_id) - set(list_candidate_ids))

    '''
    K를 S로 대체한 후 디렉토리에 K-어쩌구를 S-어쩌구로 바꿈
    '''
    for pillid in list_non_candidate_pillid :
        new_id = pillid.replace('K', 'S')
        path_old = os.path.join(args.dir_pill_class_base, pillid)
        path_new = os.path.join(args.dir_pill_class_base, new_id)
        shutil.move(path_old, path_new)







'''
현재 파일 실행시 실행되는 부분
args는 get_cli_args를 통해 저장
logger, file_log는 말그대로 log 파일 생성/작성

make_pill_class_list는 위에 정의되어있음. 주석해제하고 사용하면 될듯
rename_non_candidate_to_s_id는 json파일에 없는 디렉토리가 있는 경우 폴더 이름의 K를 S로 변경. 주석처리할지 고민 필요
'''
if __name__ == '__main__':

    # job = 'hrnet_w64'
    job = 'resnet152'
    file_num = input('Enter file number : ', )
    file_name = f'file_{file_num}'
    args = get_cli_args(job=job, run_phase='train', aug_level=1, dataclass='0', file_number=file_num)
    args.logger = utils.create_logging(args.file_log)
    make_pill_class_list(args, file_name)
    # rename_non_candidate_to_s_id(args)
    print('job done')
