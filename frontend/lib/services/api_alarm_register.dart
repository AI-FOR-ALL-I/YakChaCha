import 'package:dio/dio.dart';
import 'package:frontend/controller/auth_controller.dart';
import 'api_constants.dart';
import 'package:curl_logger_dio_interceptor/curl_logger_dio_interceptor.dart';
import 'package:get/get.dart' as getX;
import 'package:frontend/controller/profile_controller.dart';

final dio = Dio(
  BaseOptions(
    baseUrl: ApiConstants.baseurl,
  ),
);

final controller = getX.Get.find<ProfileController>();
final authController = getX.Get.find<AuthController>();
final tempProfileLinkSeq = controller.profileLinkSeq;
final accessToken = authController.accessToken;

// 알약 등록

class ApiAlarmRegister {
  static Future<Response> alarmRegister(
      Map data, String type, int reminderSeq) async {
    final path = ApiConstants.alarmRegister
        .replaceAll('{profileLinkSeq}', tempProfileLinkSeq.toString());
    if (type == "create") {
      dio.interceptors.add(CurlLoggerDioInterceptor(printOnSuccess: true));
      return dio.post(path,
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken'
          }),
          data: data);
    } else {
      dio.interceptors.add(CurlLoggerDioInterceptor(printOnSuccess: true));
      return dio.put(path + '/$reminderSeq',
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken'
          }),
          data: data);
    }
  }

  static Future<void> alarmDelete(reminderSeq) {
    final path = ApiConstants.alarmRegister
        .replaceAll('{profileLinkSeq}', tempProfileLinkSeq.toString());

    dio.interceptors.add(CurlLoggerDioInterceptor(printOnSuccess: true));
    return dio.put(
      path + '/$reminderSeq/delete',
      options: Options(headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      }),
    );
  }
}
