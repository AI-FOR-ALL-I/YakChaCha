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

  static Future<Response> logout(String accessToken) async {
    // accessToken은 따로 getX? storage에 저장할거니까 일단은 임의로 String 넣어놓음

    return dio.put(ApiConstants.logout,
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Authorzation': 'Bearer $accessToken'
        }));
  }

  // 알약 등록
  static Future<Response> pillRegister(List data) async {
    print('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
    print('${data}, !!!!!!!!!!!');
    return dio.post(ApiConstants.pillRegister,
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Authorization': ApiConstants.TOKEN
        }),
        data: data);
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
