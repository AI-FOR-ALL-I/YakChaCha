import 'package:frontend/services/my_pill_api.dart';
import 'package:frontend/services/taken_pill_api.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyPillController extends GetxController {
  var myPillList = [];
  Future getPillList() async {
    try {
      myPillList = await MyPillApi.getMyPill();
    } catch (e) {
      print(e);
    }
    update();
  }

  var takenPillList = [];
  Future getTakenPillList() async {
    try {
      takenPillList = await TakenPillApi.getTakenPill();
    } catch (e) {
      print(e);
    }
    update();
  }

  void clear() {
    myPillList = [];
    update();
  }
}
