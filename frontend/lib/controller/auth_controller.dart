import 'package:frontend/services/api_client.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

class AuthController extends GetxController {
  final RxString _accessToken = ''.obs;
  final RxString _refreshToken = ''.obs;

  String get accessToken => _accessToken.value;
  String get refreshToken => _refreshToken.value;

  bool get isLoggedIn => accessToken.isNotEmpty;

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

  clearTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken');
    await prefs.remove('refreshToken');
    _accessToken.value = '';
    _refreshToken.value = '';
  }

  // 만료처리
  Future<bool> refreshTokenIfNeeded() async {
    if (!_isAccessTokenExpired()) {
      return true;
    }

    // 만료되었으면 refreshToken으로 새로운 accessToken을 발급받습니다.
    final result = await _refreshAccessToken();

    if (result.isNotEmpty) {
      saveTokens(result['accessToken'], result['refreshToken']);
      print('renewtoken$accessToken::\n$refreshToken');
      return true;
    }
    // refreshToken으로 accessToken을 발급받지 못하면 로그아웃 처리합니다.
    clearTokens();
    print('clearedtoken$accessToken::\n$refreshToken');
    return false;
  }

  // 만료 시간 체크
  bool _isAccessTokenExpired() {
    // accessToken의 만료 시간을 확인합니다.
    // 예시로 accessToken이 만료되면 1분 뒤로 설정합니다.
    final expiredTime = DateTime.now().add(const Duration(minutes: 1));
    final accessTokenExpired = expiredTime.isBefore(DateTime.now());

    return accessTokenExpired;
  }

  Future<Map<String, dynamic>> _refreshAccessToken() async {
    // refreshToken을 사용하여 새로운 accessToken을 발급받는 API를 호출합니다.
    // 결과는 Map<String, dynamic> 형식으로 반환합니다.
    try {
      final response = await dio.put(
          'https://j8a803.p.ssafy.io/api/accounts/refresh',
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $refreshToken'
          }));
      if (response.statusCode == 200) {
        return response.data;
      } else {
        // API 호출이 성공하지 않으면 빈 Map을 반환합니다.
        return <String, dynamic>{};
      }
    } on DioError {
      // API 호출이 성공하지 않으면 빈 Map을 반환합니다.
      return <String, dynamic>{};
    }
  }
}
