import 'package:get/get.dart';

class PillRegisterController extends GetxController {
  List displayList = [];
  // 안에 들어가는 요소는 {item_seq:1, img : 'url', item_name:'name', warn_pregnant:false, warn_age:false,warn_old:false,collide:false}

  List registerList = [];
  // 안에 들어가는 요소 {item_seq:1, start_date:'YYYY-MM-DD', end_date:'YYYY-MM-DD', tag_list:[['태그이름',1], ['태그이름', 2]]}

  List tagList = [
    ['태그명', 1],
    ['태그명', 2]
  ];

  // 리스트에 없다면 등록
  void add(data) {
    bool isDisplayIList = displayList.any((pill) =>
        pill.containsKey('item_seq') && pill['item_seq'] == data['item_seq']);
    if (!isDisplayIList) {
      displayList.add(data);
    }
    bool isRegisterList = registerList.any((pill) =>
        pill.containsKey('item_seq') && pill['item_seq'] == data['item_seq']);
    if (!isRegisterList) {
      registerList.add(data);
    }
    update();
  }

  // 해당 약 삭제
  void delete(seq) {
    bool isDisplayIList = displayList
        .any((pill) => pill.containsKey('item_seq') && pill['item_seq'] == seq);
    if (isDisplayIList) {
      displayList.removeWhere((pill) => pill['item_seq'] == seq);
    }
    bool isRegisterList = displayList
        .any((pill) => pill.containsKey('item_seq') && pill['item_seq'] == seq);
    if (isRegisterList) {
      registerList.removeWhere((pill) => pill['item_seq'] == seq);
    }
    update();
  }

  // 시작일 업데이트
  void updateStartDate(seq, date) {
    for (int i = 0; i < registerList.length; i++) {
      if (registerList[i]['item_seq'] == seq) {
        registerList[i]['start_date'] = date;
        break; // 찾았으면 for문을 더 이상 돌 필요가 없으므로 break를 사용합니다.
      }
    }
    update();
  }

  // 종료일 업데이트
  void updateEndDate(seq, date) {
    for (int i = 0; i < registerList.length; i++) {
      if (registerList[i]['item_seq'] == seq) {
        registerList[i]['end_date'] = date;
        break; // 찾았으면 for문을 더 이상 돌 필요가 없으므로 break를 사용합니다.
      }
    }
    update();
  }

  // tag_list 업데이트
  void deleteTag(seq, tagName) {
    for (int i = 0; i < registerList.length; i++) {
      if (registerList[i]['item_seq'] == seq) {
        registerList[i]['tag_list'].removeWhere((tag) => tag[0] == tagName);
        break; // 찾았으면 for문을 더 이상 돌 필요가 없으므로 break를 사용합니다.
      }
    }
    update();
  }

  // 기존에 있는 태그를 눌렀을 때
  void addTag(seq, tagName, color) {
    for (int i = 0; i < registerList.length; i++) {
      if (registerList[i]['item_seq'] == seq) {
        registerList[i]['tag_list'].add([tagName, color]);
        break; // 찾았으면 for문을 더 이상 돌 필요가 없으므로 break를 사용합니다.
      }
    }
    update();
  }

  // 새로운 태그를 입력할 때
  void addNewTag(seq, tagName, color) {
    bool found = false;
    for (List tag in tagList) {
      if (tag[0] == tagName) {
        addTag(seq, tagName, tag[1]);
        bool found = true;
        break;
      }
      if (!found) {
        addTag(seq, tagName, color);
      }
    }
    update();
  }

  // 특정 기준 오름차순 정렬
  // myScore.sort((a, b) => a.name.compareTo(b.name));
}
