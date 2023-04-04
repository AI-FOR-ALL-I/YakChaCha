import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyPillController extends GetxController {
  final RxInt _isOn = 0.obs;
  int get isOn => _isOn.value;

  void increment(int what) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('isOn', isOn);
    _isOn.value = what + 1;
  }
}
