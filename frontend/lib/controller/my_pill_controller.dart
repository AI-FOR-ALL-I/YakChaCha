import 'package:get/get.dart';

class MyPillController extends GetxController {
  final isOn = 0.obs;

  void increment() {
    isOn.value++;
  }
}