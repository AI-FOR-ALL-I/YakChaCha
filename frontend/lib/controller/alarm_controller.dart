import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:frontend/models/my_pill_model.dart';
import 'package:dio/dio.dart' as dio;
import 'package:frontend/services/api_alarm.dart';
import 'dart:convert';

// A Unified Data Infrastructure Architecture
class AlarmController extends GetxController {
  var alarmList = [];

  Future getAlarmList() async {
    try {
      var response = await ApiAlarm.getAlarmList();
      alarmList = response.data["data"];
    } catch (e) {
      print(e);
    }
    update();
  }

  Map alarmDetail = new Map();

  Future getAlarmDetail(int alarmSeq) async {
    try {
      var response = await ApiAlarm.getAlarmDetail(alarmSeq);
      alarmDetail = response.data["data"];
      return alarmDetail;
    } catch (e) {
      print(e);
    }
    update();
  }

  Future takePill(int alarmSeq) async {
    try {
      var response = await ApiAlarm.takePills(alarmSeq);
      getAlarmList();
    } catch (e) {
      print(e);
    }
    update();
  }
}
