import cv2

from get_cli_args import get_cli_args
from pathlib import Path
import utils
import numpy
import os

'''
image.ndim == 3 이면 opencv 통해서 convert Color? cv2.BGR2GRAY
blur_map으로 어쩌고
score에 저장하여 리턴
'''
def estimate_sharpness(image: numpy.array, threshold: int = 100):
    if image.ndim == 3:
        image = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)

    blur_map = cv2.Laplacian(image, cv2.CV_64F)
    score = numpy.var(blur_map)
    return score



'''
현재 파일 외에 다른곳에서 호출되지 않음.
최초 pathdir_dest에 dir_pill_class_base 경로 저장
주피터 노트북 기준 경로  /home/jupyter-j8a803/proj/proj_pill/pill_data/pill_data_croped
-> 수정필요없음 해당 위치에 json 파일 저장, 호출, 수정 후 저장 예정
'''
def make_label_sharpness(args, file_name):
    pathdir_dest = Path(os.path.join(args.dir_pill_class_base, file_name))
    # dict_pill_prescription_type = utils.read_dict_from_json(args.json_pill_prescription_type)['pill_prescription_type']
    
    '''
    해당 위치에 1000개짜리(0~999) json 파일 호출
    list_pills_label_path_sharp_score 에 해당 리스트 저장
    형식)
    [
        [
            0,
            "K-037589",
            149.2305576160079,
            45.62416263502471,
            422.67862429732025
        ],
        [
            1,
            "K-029534",
            103.72038138092651,
            29.223249162946423,
            289.5755319448373
        ],
        ...,
        [
            999,
            "K-017220",
            10.369818528154884,
            4.775476384589893,
            23.1631993103504
        ]
    ]
    
    count에 해당 리스트의 len 저장(1000 저장)

    '''
    list_pills_label_path_sharp_score = []
    list_count = 0
    list_pillids =[]
    
    try:
        dict_temp = utils.read_dict_from_json(args.json_pill_label_path_sharp_score)
        list_pills_label_path_sharp_score = dict_temp['pill_label_path_sharp_score']

        list_count = len(list_pills_label_path_sharp_score)

        list_pillids = []

        for label, pillid, score_mean, score_min, score_max in list_pills_label_path_sharp_score:
            list_pillids.append(pillid)
    except:
        pass
        
    '''
    list_pills_sharp_score 리스트 생성

    pathdir_dest.iterdir() : 해당 디렉토리 안에 있는 것 순회
    pathdir_pill_class에 저장
    .id_dir로 디렉토리인지 확인. 아니면 continue
    '''
    list_pills_sharp_score = []
    count = list_count
    # 중간 file_## 경로 추가
    for pathdir_pill_class in pathdir_dest.iterdir():
        # 추가, 기존 json파일에 해당 약이 이미 있는 경우 continue
        if not pathdir_pill_class.is_dir() or str(pathdir_pill_class.parts[-1]) in list_pillids:
            continue
        
        '''
        print로 현재 디렉토리 being estimated 출력
        count += 1
        list_pill_class_shape_score 리스트 생성
        pathdir_pill_class(K-어쩌고 폴더) iterdir로 순회
        pathfile_pill_png로 저장
        suffix가 json이면 continue (png랑 json만 있으므로..)
        score는 위에 def되어있는 estimate_sharpness로 계산하여 저장
        list_pill_class_shape_score에 append (각 k-어쩌고 폴더마다 리스트가 생김)
        '''
        print(f'{count}, {pathdir_pill_class} is being estimated')
        count += 1
        list_pill_class_shape_score = []
        for  pathfile_pill_png in pathdir_pill_class.iterdir():
            if pathfile_pill_png.suffix == '.json':
                continue
            score = estimate_sharpness(utils.open_opencv_file(str(pathfile_pill_png)))
            list_pill_class_shape_score.append(score)
        
        '''
        전체 png파일에 대해 계산 후 score_min, score_max, score_mean 계산
        list_pills_sharp_score 리스트안에 리스트형태로 append 내용물은 ["K-017220", 10.369818528154884, 4.775476384589893, 23.1631993103504]
        '''
        score_min = min(list_pill_class_shape_score)
        score_max = max(list_pill_class_shape_score)
        score_mean = sum(list_pill_class_shape_score)/len(list_pill_class_shape_score)
        list_pills_sharp_score.append([str(pathdir_pill_class.stem), score_mean, score_min,score_max])

    '''
    pathdir_dest(pill_data_croped) 안의 파일 순회 끝나면
    list_pills_sharp_score sharp min 기준으로 정렬. (왜 하는지는 모르겠음)
    list_pills_label_path_sharp_score에 저장
    -> 수정완료) 기존 리스트 뒤에 추가 : = 을 +=로 수정
    저장 내용 확인. 기존 list_pills_sharp_score에 enumerate해서 for문으로 순회. label에 list_count 더해주면 될듯

    dict_temp로 딕셔너리로 저장후 save_dict_to_json으로 json파일로 저장.
    '''
    list_pills_sharp_score = sorted(list_pills_sharp_score, key=lambda a: a[2], reverse=True)           # sharp min 기준으로 정렬.
    list_pills_label_path_sharp_score += [ [label + list_count, pathname, score_mean, score_min, score_max] for label, ( pathname, score_mean, score_min, score_max ) in enumerate(list_pills_sharp_score)]

    dict_temp = { 'pill_label_path_sharp_score':list_pills_label_path_sharp_score}

    utils.save_dict_to_json(dict_temp, args.json_pill_label_path_sharp_score)



'''
json_pill_label_path_sharp_score 딕셔너리로 읽어와서 dict_temp에 저장
list_pills_label_path_sharp_score 에 해당 리스트 저장

dict_label_pillid 빈 딕셔너리
위에 json 파일에서 불러온 리스트 enumerate 해서
for문으로 idx, (label, pillid, score_mean, score_min, score_max) 저장
idx가 args.num_classes 보다 작을 동안 dict_label_pillid에 label: pillid update

따로 사용되지는 않는듯.
'''
def get_dict_label_pillid(args):
    dict_temp = utils.read_dict_from_json(args.json_pill_label_path_sharp_score)
    list_pills_label_path_sharp_score = dict_temp['pill_label_path_sharp_score']

    dict_label_pillid = {}
    for idx, (label, pillid, score_mean, score_min, score_max) in enumerate(list_pills_label_path_sharp_score):
#         if idx >= args.num_classes:
#             break
        # print(f'{label},{pillid},{score_mean},{score_min},{score_max}')
        dict_label_pillid.update({label: pillid})

    return dict_label_pillid



'''
위에랑 같음.
dict에 label:pillid 저장하는지 pillid:label 저장하는지 차이
gen_pill에서 사용됨 나중에 확인
'''
def get_dict_pillid_label(args):
    dict_temp = utils.read_dict_from_json(args.json_pill_label_path_sharp_score)
    list_pills_label_path_sharp_score = dict_temp['pill_label_path_sharp_score']

    dict_pillid_label = {}
    for idx, (label, pillid, score_mean, score_min, score_max) in enumerate(list_pills_label_path_sharp_score):
#         if idx >= args.num_classes:
#             break
        dict_pillid_label.update({pillid:label})

    return dict_pillid_label



'''
실제 실행되는 부분
args 호출
log 남기고
make_label_sharpness 실행
주석으로는 get_dict_pillid_label 실행과
dict_label_pillid = get_dict_label_pillid 저장이 있음
'''
if __name__ == '__main__':

    # job = 'hrnet_w64'
    job = 'resnet152'
    file_num = input('Enter file number : ', )
    file_name = f'file_{file_num}'
    args = get_cli_args(job=job, run_phase='train', aug_level=1, dataclass='0', file_number=file_num)
    args.logger = utils.create_logging(args.file_log)
    make_label_sharpness(args, file_name)
    # get_dict_pillid_label(args)
    # dict_label_pillid = get_dict_label_pillid(args)
    print('done')
