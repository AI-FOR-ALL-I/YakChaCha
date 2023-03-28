import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseController extends GetxController {
  final _firebaseToken = ''.obs;
  String get firebaseToken => _firebaseToken.value;

  @override
  void onInit() {
    super.onInit();
    // shared_preferences에서 토큰 값을로드합니다.
    loadToken();
  }

  void loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _firebaseToken.value = prefs.getString('firebaseToken') ?? '';
  }

  void saveTokens(String firebaseToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('firebaseToken', firebaseToken);
    _firebaseToken.value = firebaseToken;
  }

  void clearTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('firebaseToken');
    _firebaseToken.value = '';
  }
}
