import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:frontend/models/my_pill_model.dart';
import 'package:dio/dio.dart' as dio;
import 'package:frontend/services/api_alarm.dart';
import 'dart:convert';

// A Unified Data Infrastructure Architecture
class AlarmController extends GetxController {
  Future getAlarmList() async {
    try {
      var response = await ApiAlarm.getAlarmList();
      print(response);
    } catch (e) {
      print(e);
    }
  }

  Map alarmDetail = new Map();

  Future getAlarmDetail(int alarmSeq) async {
    try {
      var response = await ApiAlarm.getAlarmDetail(alarmSeq);
      alarmDetail = response.data["data"];
      print(alarmDetail);
    } catch (e) {
      print(e);
    }
  }
}
