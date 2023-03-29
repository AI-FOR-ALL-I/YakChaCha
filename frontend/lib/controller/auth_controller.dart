import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  final _accessToken = ''.obs;
  final _refreshToken = ''.obs;

  String get accessToken => _accessToken.value;
  String get refreshToken => _refreshToken.value;

  @override
  void onInit() {
    super.onInit();
    // shared_preferences에서 토큰 값을로드합니다.
    _loadTokens();
  }

  void _loadTokens() async {
    final prefs = await SharedPreferences.getInstance();
    _accessToken.value = prefs.getString('accessToken') ?? '';
    _refreshToken.value = prefs.getString('refreshToken') ?? '';
  }

  void saveTokens(String accessToken, String refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('accessToken', accessToken);
    await prefs.setString('refreshToken', refreshToken);
    _accessToken.value = accessToken;
    _refreshToken.value = refreshToken;
  }

  void clearTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken');
    await prefs.remove('refreshToken');
    _accessToken.value = '';
    _refreshToken.value = '';
  }
}
