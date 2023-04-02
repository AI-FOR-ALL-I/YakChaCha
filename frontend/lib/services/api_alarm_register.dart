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

// 알약 등록

class ApiAlarmRegister {
  static Future<Response> alarmRegister(Map data) async {
    return dio.post(ApiConstants.alarmRegister,
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Authorization': ApiConstants.TOKEN
        }),
        data: data);
  }
}
