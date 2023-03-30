import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:frontend/models/my_pill_model.dart';
import 'package:dio/dio.dart' as dio;
import 'package:frontend/services/api_alarm_register.dart';
import 'dart:convert';

// A Unified Data Infrastructure Architecture
class AlarmPillController extends GetxController {
  // 최종 형식 {
  // "title": "저녁약",
  // "time": "06:30:PM",
  // "medicineList": [
  //     {"medicineSeq": 1, "count": 1},
  //     {"medicineSeq": 3, "count": 4}
  //     ]}

  // 최종적으로 보낼 Map
  Map registerMap = {"title": null, "time": null, "mdicineList": []};

  // 선택된 약 : [{"medicineSeq": 3, "count": 4}]
  List selectedList = [];

  // 선택된 약을 보여주기 위한 리스트
  List displayList = [];

  // 선택된 약을 약 선택 화면에서 보여주기 위한 리스트
  List tempList = []; // [1, 2, 3,]

  // 내가 먹고 있는 모든 약
  List myPillList = [];

  // 타이틀 설정
  void setTitle(title) {
    registerMap["title"] = title;
    update();
  }

  // 시간 설정
  void setTime(time) {
    String selectedTime = DateFormat('h:mm:a').format(time);
    registerMap['time'] = selectedTime;
    update();
  }

  // 내 약 선택 페이지용 선택 메서드
  void selectTemp(seq) {
    bool isInTempList = tempList.contains(seq);
    if (isInTempList) {
      tempList.remove(seq);
    } else {
      tempList.add(seq);
    }

    update();
  }

  // 알람에 등록할 약 추가
  void add(seq, img, tagList, title) {
    selectedList.add({"medicineSeq": seq, "count": 1});
    displayList.add({
      "medicineSeq": seq,
      "count": 1,
      "title": title,
      "img": img,
      "tagList": tagList
    });
    update();
  }

  // 알람에 등록한 약 빼기
  void delete(seq) {
    selectedList.removeWhere((pill) => pill['medicineSeq'] == seq);
    displayList.removeWhere((pill) => pill['medicineSeq'] == seq);
    update();
  }

  // 선택 페이지에 서브밋
  void submitTemp() {
    for (int i = 0; i < myPillList.length; i++) {
      int index = myPillList[i].itemSeq;
      if (tempList.contains(index) &&
          !selectedList.any((pill) => pill['medicineSeq'] == index)) {
        MyPillModel target =
            myPillList.firstWhere((pill) => pill.itemSeq == index);
        add(index, target.img, target.tagList, target.itemName);
      } else if (!tempList.contains(index) &&
          selectedList.any((pill) => pill['medicineSeq'] == index)) {
        delete(index);
      }
    }
    print(displayList);
    update();
  }

  // 약 카운트 수정
  void changeCount(seq, count) {
    if (count == -1 &&
        selectedList
                .firstWhere((pill) => pill['medicineSeq'] == seq)["count"] <=
            1) {
    } else {
      displayList.firstWhere((pill) => pill['medicineSeq'] == seq)["count"] +=
          count;
      selectedList.firstWhere((pill) => pill['medicineSeq'] == seq)["count"] +=
          count;
    }

    update();
  }

  void saveMyPill(list) {
    myPillList = [];
    myPillList = list;
    update;
  }

  Future dioRequest() async {
    registerMap["medicineList"] = selectedList;
    try {
      dio.Response response = await ApiAlarmRegister.alarmRegister(registerMap);
      Map<String, dynamic> data = response.data;
      return data['success'];
    } catch (e) {
      print(e);
    }
  }

  void clear() {
    Map registerMap = {"title": null, "time": null, "mdicineList": []};
    List selectedList = [];

    List displayList = [];

    List tempList = []; // [1, 2, 3,]

    List myPillList = [];
  }
}
