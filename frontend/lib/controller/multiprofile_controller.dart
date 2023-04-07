import 'package:get/get.dart';

class MultiProfileController extends GetxController {
  final RxList multiProfileList = [].obs;

  setMultiProfile(List multiProfile) {
    multiProfileList.value = multiProfile;
  }
}
