import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart' as dio;
import 'package:frontend/services/api_pill_register.dart';
import 'package:frontend/services/api_search.dart';
import 'dart:convert';
import 'package:frontend/controller/alarm_pill_controller.dart';

class PillRegisterController extends GetxController {
  RxList<dynamic> displayList = RxList<dynamic>([]);
  // 안에 들어가는 요소는 {itemSeq:1, img : 'url', itemName:'name', warnPregnant:false, warnAge:false,warnOld:false,collide:false}

  List registerList = [];
  // 안에 들어가는 요소 {itemSeq:1, start_date:'YYYY-MM-DD', end_date:'YYYY-MM-DD', tag_list:[['태그이름',1], ['태그이름', 2]]}

  // TODO: 여기에 사용자가 만든 모든 태그를 다 받아오기
  // 이후
  List tagList = [];

  // 리스트에 없다면 등록
  void add(data) {
    bool isDisplayIList = displayList.any((pill) =>
        pill.containsKey('itemSeq') && pill['itemSeq'] == data['itemSeq']);
    if (!isDisplayIList) {
      displayList.add(data);

      // update();
    }
    bool isRegisterList = registerList.any((pill) =>
        pill.containsKey('itemSeq') && pill['itemSeq'] == data['itemSeq']);
    if (!isRegisterList) {
      var tempMap = {
        'itemSeq': data['itemSeq'],
        'startDate': DateFormat('yyyy-MM-dd').format(DateTime.now()),
        'endDate': DateFormat('yyyy-MM-dd').format(DateTime.now()),
        'tagList': []
      };
      registerList.add(tempMap);
    }
    // update();
    print('최종 리스트 : $displayList');
  }

  // 해당 약 삭제
  void delete(seq) {
    bool isDisplayIList = displayList
        .any((pill) => pill.containsKey('itemSeq') && pill['itemSeq'] == seq);
    if (isDisplayIList) {
      displayList.removeWhere((pill) => pill['itemSeq'] == seq);
    }
    bool isRegisterList = displayList
        .any((pill) => pill.containsKey('itemSeq') && pill['itemSeq'] == seq);
    if (isRegisterList) {
      registerList.removeWhere((pill) => pill['itemSeq'] == seq);
    }
    update();
  }

  // 시작일 업데이트
  void updateStartDate(seq, date) {
    for (int i = 0; i < registerList.length; i++) {
      if (registerList[i]['itemSeq'] == seq) {
        registerList[i]['startDate'] = date;
        break; // 찾았으면 for문을 더 이상 돌 필요가 없으므로 break를 사용합니다.
      }
    }
    update();
  }

  // 종료일 업데이트
  void updateEndDate(seq, date) {
    for (int i = 0; i < registerList.length; i++) {
      if (registerList[i]['itemSeq'] == seq) {
        registerList[i]['endDate'] = date;
        break; // 찾았으면 for문을 더 이상 돌 필요가 없으므로 break를 사용합니다.
      }
    }
    update();
  }

  // tag 지우기
  void deleteTag(seq, tagName) {
    for (int i = 0; i < registerList.length; i++) {
      if (registerList[i]['itemSeq'] == seq) {
        registerList[i]['tagList'].removeWhere((tag) => tag[0] == tagName);
        print(registerList[i]['tagList']);
        break;
      }
    }
    update();
  }

  // 기존에 있는 태그를 눌렀을 때
  void addTag(seq, tagName, color) {
    for (int i = 0; i < registerList.length; i++) {
      if (registerList[i]['itemSeq'] == seq) {
        registerList[i]['tagList'].add([tagName, color.toString()]);
        break;
      }
    }

    // tagList에 없는 태그인 경우 추가
    bool isExistTag = tagList.any((tag) => tag["name"] == tagName);
    if (!isExistTag) {
      tagList.add({"name": tagName, "color": color});
    }

    update();
  }

  // 새로운 태그를 입력할 때
  void addNewTag(seq, tagName, color) {
    bool found = false;
    for (Map tag in tagList) {
      // 이미 태그 리스트에 있으면
      if (tag["name"] == tagName) {
        addTag(seq, tagName, int.parse(tag[1]));
        found = true;
        break;
      }
    }
    if (!found) {
      addTag(seq, tagName, color);
    }
    update();
  }

  // 나갈때 기록 다 지우기
  void clear() {
    displayList.clear();
    registerList = [];
    tagList = [];
    update();
  }

  // TODO: 여기서 dio 요청보내기
  Future dioRequest() async {
    try {
      dio.Response response = await ApiPillRegister.pillRegister(registerList);
      Map<String, dynamic> data = response.data;
      print(data);
      return data['success'];
    } catch (e) {
      print(e);
    }
  }

  // 알약 사진을 검색
  List aiPillSeq = [];

  Future imgSearchFinal(List data) async {
    try {
      if (data != null) {
        dio.Response response = await ApiSearch.imgSearchFinal(data);
        Map<String, dynamic> response2 = response.data;
        return response2["data"];
      }
    } catch (e) {
      print(e);
    }
  }

  // 처방전으로 등록
  List ocrPillSeq = [];

  Future ocrSearchFinal(List data) async {
    try {
      if (data != null) {
        dio.Response response = await ApiSearch.ocrSearchFinal(data);
        Map<String, dynamic> response2 = response.data;
        print(response2["data"]);
        update();
        return response2["data"];
      }
    } catch (e) {
      print(e);
    }
  }

  ocrToList(ocrResultList) {
    print('ocrResultList에서 for문 돌리기 직전');
    for (int i = 0; i < ocrResultList.length; i++) {
      add(ocrResultList[i]);
    }
    update();
  }

  // 특정 기준 오름차순 정렬
  // myScore.sort((a, b) => a.name.compareTo(b.name));

  // tag 불러오기 (alarm_pill_controller에 있는 함수 활용 )
  AlarmPillController alarmPillController =
      Get.put<AlarmPillController>(AlarmPillController());

  getTagList() async {
    tagList = await alarmPillController.getTagList() ?? [];
    // print(tagList);
    update();
  }
}
