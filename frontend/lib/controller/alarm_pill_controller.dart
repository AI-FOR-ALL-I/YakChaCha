import 'package:get/get.dart';

class AlarmPillController extends GetxController {
  List selectedList = [];

  void add(tempList) {
    selectedList = tempList;
    selectedList.sort();
    update();
    print(selectedList);
  }
  // 특정 기준 오름차순 정렬
  // myScore.sort((a, b) => a.name.compareTo(b.name));

  void minus(medicineSeq) {
    selectedList
        .removeWhere((element) => element['medicineSeq'] == medicineSeq);
    update();
  }

  void clear() {
    selectedList = [];
    update();
  }
}
