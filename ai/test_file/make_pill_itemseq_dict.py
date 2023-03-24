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


def search_itemseq_by_pillid(pill_id, base_dir):
    pill_itemseq_dict = Path(os.path.join(base_dir, 'proj_pill', 'pill_itemseq_dict.json'))
    dict_temp = read_dict_from_json(pill_itemseq_dict)
    dict_pillid_iteminfo = dict_temp["dict_pillid_iteminfo"]
    return dict_pillid_iteminfo.get(pill_id, 'No data')


def search_pillid_by_itemseq(item_seq, base_dir):
    pill_itemseq_dict = Path(os.path.join(base_dir, 'proj_pill', 'pill_itemseq_dict.json'))
    dict_temp = read_dict_from_json(pill_itemseq_dict)
    dict_itemseq_pillid = dict_temp["dict_itemseq_pillid"]
    return dict_itemseq_pillid.get(item_seq, 'No data')


def make_pill_itemseq_dict(base_dir):
    pathdir_dest = Path(os.path.join(base_dir, 'pill_data', 'pill_data_label'))

    dict_pillid_iteminfo = {}
    dict_itemseq_pillid = {}
    list_count = 0
    list_pillids = []

    for pathdir_pill in pathdir_dest.iterdir():
        if not pathdir_pill.is_dir():
            continue

        '''
        pill_id에 K-어쩌구 값 저장
        '''
        pill_id = pathdir_pill.parts[-1].split('_')[0]
        list_pillids.append(pill_id)

        print(f'{list_count}, reading {pill_id}...')
        list_count += 1
        
        '''
        dir 들어가서 첫번째 json 파일 dict로 열고 images 키로 딕셔너리 저장. 
        해당 딕셔너리에서 item_seq:pill_id, pill_id:item_seq 딕셔너리 생성? dl_name까지 붙일것.
        '''
        for pill_info in pathdir_pill.iterdir():
            dict_temp = read_dict_from_json(pill_info)
            dict_pill_info = dict_temp["images"][0]
            item_seq = dict_pill_info["item_seq"]
            dl_name = dict_pill_info["dl_name"]
            img_key = dict_pill_info["img_key"]
            
            dict_itemseq_pillid[item_seq] = pill_id
            dict_pillid_iteminfo[pill_id] = (int(item_seq), dl_name, img_key)
            break

    dict_temp = {'dict_itemseq_pillid': dict_itemseq_pillid, 'dict_pillid_iteminfo': dict_pillid_iteminfo}
    json_pill_itemseq_dict = f'pill_itemseq_dict.json'
    json_pill_itemseq_dict = os.path.join(base_dir, 'proj_pill', json_pill_itemseq_dict)
    save_dict_to_json(dict_temp, json_pill_itemseq_dict)

if __name__ == '__main__':

    base_dir = r'C:\Users\SSAFY\Desktop\pill_data\test\proj_pill'
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