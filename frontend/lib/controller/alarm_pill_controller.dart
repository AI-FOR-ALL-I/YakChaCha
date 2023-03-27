import 'package:get/get.dart';

class AlarmPillController extends GetxController {
  List selectedList = [];

  void add(tempList) {
    selectedList.addAll(tempList);
    update();
    print(selectedList);
  }

  void minus(medicineSeq) {
    selectedList
        .removeWhere((element) => element['medicineSeq'] == medicineSeq);
    update();
  }
}
