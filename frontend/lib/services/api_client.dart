import 'package:dio/dio.dart';
import 'package:frontend/controller/auth_controller.dart';
import 'api_constants.dart';
import 'package:curl_logger_dio_interceptor/curl_logger_dio_interceptor.dart';
import 'package:get/get.dart' as getX;

final dio = Dio(
  BaseOptions(
    baseUrl: ApiConstants.baseurl,
  ),
);

final authController = getX.Get.find<AuthController>();

class ApiClient {
  static Future<Response> login(String type, String? email, String? id,
      String? deviceToken, String? kakaoName) async {
    // interceptor
    dio.interceptors.add(CurlLoggerDioInterceptor(printOnSuccess: true));
    final data = {
      'type': type,
      'id': id,
      'email': email,
      'deviceToken': deviceToken,
      'name': kakaoName,
    };
    return dio.post(ApiConstants.login,
        data: data,
        options: Options(headers: {'Content-Type': 'application/json'}));
  }

  // 로그아웃
  static Future<Response> logout() async {
    final accessToken = authController.accessToken;
    dio.interceptors.add(CurlLoggerDioInterceptor(printOnSuccess: true));
    return dio.put(ApiConstants.logout,
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken'
        }));
  }

  // 탈퇴하기
  static Future<Response> withDraw(String accessToken) async {
    final accessToken = authController.accessToken;
    dio.interceptors.add(CurlLoggerDioInterceptor(printOnSuccess: true));
    return dio.put(ApiConstants.withdraw,
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken'
        }));
  }

  // 알람 등록

  // 호출방법은 아래와 같은 방법인듯.
  /*
  Future<void> fetchUsers() async {
  try {
    Response response = await ApiClient.getUsers();
    // handle response data
  } catch (e) {
    // handle error
  }
}
Future<void> fetchUsers() async {
  try {
    Response response = await ApiClient.getUsers();

    List<dynamic> users = response.data;
    
    // handle users data
  } catch (e) {
    // handle error
  }
} 
Future<void> loginUser(String email, String password) async {
  try {
    Response response = await ApiClient.login(email, password);

    // handle response data
  } catch (e) {
    // handle error
  }
}

Future<void> registerUser(String name, String email, String password) async {
  try {
    Response response = await ApiClient.register(name, email, password);

    // handle response data
  } catch (e) {
    // handle error
  }
}
  */
}
