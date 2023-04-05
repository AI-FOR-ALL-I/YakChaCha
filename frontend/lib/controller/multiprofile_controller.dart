import 'package:get/get.dart';

class MultiProfileController extends GetxController {
  final RxList multiProfileList = [].obs;

  void setMultiProfile(List multiProfile) {
    multiProfileList.value = multiProfile;
  }
}
