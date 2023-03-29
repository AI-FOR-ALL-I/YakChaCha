from pathlib import Path
import os
import codecs, json



def save_dict_to_json(dict_save, filejson, mode='w'):
    with codecs.open(filejson, mode, encoding='utf-8') as f:
        json.dump(dict_save, f, ensure_ascii=False, indent=4)


def read_dict_from_json(filejson):
    if not os.path.isfile(filejson) :
        return None
    with codecs.open(filejson, 'r', encoding='utf-8') as f:
        obj = json.load(f)
        return obj


def search_itemseq_by_pillid(pill_id, pill_itemseq_dict):
#     pill_itemseq_dict = Path(os.path.join(base_dir, 'proj_pill', 'pill_itemseq_dict.json'))
    dict_temp = read_dict_from_json(pill_itemseq_dict)
    dict_pillid_iteminfo = dict_temp["dict_pillid_itemseq"]
    return dict_pillid_iteminfo.get(pill_id, 'No data')


def search_pillid_by_itemseq(item_seq, base_dir):
    pill_itemseq_dict = Path(os.path.join(base_dir, 'proj_pill', 'pill_itemseq_dict.json'))
    dict_temp = read_dict_from_json(pill_itemseq_dict)
    dict_itemseq_pillid = dict_temp["dict_itemseq_pillid"]
    return dict_itemseq_pillid.get(item_seq, 'No data')


'''
파일 경로
proj_pill(base_dir)
    |
    |- pill_data
    |   |
    |   |- pill_data_croped
    |   |
    |   |- pill_data_label
    |       |
    |       |- Training
    |       |   |
    |       |   |- single
    |       |   |   |
    |       |   |   |- TL_1_단일
    |       |   |       |
    |       |   |       |- K-000059_json
    |       |   |
    |       |   |- multi
    |       |
    |       |- Validation
    |           |
    |           |- single
    |           |   |
    |           |   |- VL_1_단일
    |           |       |
    |           |       |- K-039148_json
    |           |
    |           |- multi
    |
    |- proj_pill
        |
        |- dir_testimage
        |
        |- models

'''
def make_pill_itemseq_dict(base_dir):
    pathdir_dest = Path(os.path.join(base_dir, 'pill_data', 'pill_data_label'))

    dict_pillid_itemseq = {}
    dict_itemseq_pillid = {}
    list_count = 0
    
    for pathdir_train_valid in pathdir_dest.iterdir():
        if not pathdir_train_valid.is_dir():
            continue
        
        pathdir_single = Path(os.path.join(pathdir_train_valid, 'single'))
        for pathdir_folder in pathdir_single.iterdir():
            if not pathdir_folder.is_dir():
                continue
            
            folder_name = pathdir_folder.parts[-1].split('_')[0] + '_' + pathdir_folder.parts[-1].split('_')[1]
            for pathdir_pill in pathdir_folder.iterdir():
                if not pathdir_pill.is_dir():
                    continue
                
                pill_id = pathdir_pill.parts[-1].split('_')[0]
                # print(f'{list_count}, reading {pill_id}...')
                list_count += 1
        
                for pill_info in pathdir_pill.iterdir():
                    dict_temp = read_dict_from_json(pill_info)
                    dict_pill_info = dict_temp["images"][0]
                    item_seq = dict_pill_info["item_seq"]
                    dl_name = dict_pill_info["dl_name"]
                    img_key = dict_pill_info["img_key"]


                    temp_info = dict_pillid_itemseq.get(pill_id, 0)
                    if temp_info == 0:
                        dict_pillid_itemseq[pill_id] = (int(item_seq), dl_name, img_key, folder_name)
                    else:
                        print(f'error1: {pill_id} already in folder {temp_info[3]}. Also in {folder_name}.')
                    
                    temp_info = dict_itemseq_pillid.get(item_seq, 0)
                    if temp_info == 0:
                        dict_itemseq_pillid[item_seq] = (pill_id, dl_name, img_key, folder_name)
                    else:
                        print(f'error2: {item_seq} already saved in {temp_info[3]} as {temp_info[0]}. Also in {folder_name} as {pill_id}.')
                    break

    dict_temp = {'dict_itemseq_pillid': dict_itemseq_pillid, 'dict_pillid_itemseq': dict_pillid_itemseq}
    json_pill_itemseq_dict = f'pill_itemseq_dict.json'
    json_pill_itemseq_dict = os.path.join(base_dir, 'proj_pill', json_pill_itemseq_dict)
    save_dict_to_json(dict_temp, json_pill_itemseq_dict)


if __name__ == '__main__':

    base_dir = r'C:\Users\User\Desktop\test\proj_pill'
    # base_dir = r'C:\Users\SSAFY\Desktop\pill_data\test\proj_pill'

    # make_pill_itemseq_dict(base_dir)
    input_string = input('Enter itemseq or pillid : ', )
    output_data = False
    try:
        if input_string[0] == 'K':
            pill_id = input_string
            output_data = search_itemseq_by_pillid(pill_id, base_dir)
        else:
            item_seq = input_string
            output_data = search_pillid_by_itemseq(item_seq, base_dir)
        if output_data:
            print(output_data)
    except:
        print('Not a valid input')
    
    print('job done')