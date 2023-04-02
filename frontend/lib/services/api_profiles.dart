import 'package:dio/dio.dart';
import 'api_constants.dart';
import 'package:curl_logger_dio_interceptor/curl_logger_dio_interceptor.dart';
import 'package:get/get.dart' as getX;
import 'package:frontend/controller/auth_controller.dart';

final dio = Dio(
  BaseOptions(
    baseUrl: ApiConstants.baseurl,
  ),
);

final authController = getX.Get.find<AuthController>();

class ApiProfiles {
  static Future<Response> createProfile(String name, String gender,
      bool pregnancy, String birthDate, String nickname, int imgCode) {
    // interceptor
    final accessToken = authController.accessToken;
    dio.interceptors.add(CurlLoggerDioInterceptor(printOnSuccess: true));
    final data = {
      'name': name,
      'gender': gender,
      'pregnancy': pregnancy,
      'birthDate': birthDate,
      'nickname': nickname,
      'imgCode': imgCode,
    };

    return dio.post(ApiConstants.createProfile,
        data: data,
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken'
        }));
  }

  static Future<Response> getMultiProfiles() {
    final accessToken = authController.accessToken;
    dio.interceptors.add(CurlLoggerDioInterceptor(printOnSuccess: true));
    return dio.get(ApiConstants.getProfiles,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken'
          },
        ));
  }

  static Future<Response> getProfileInfo(int profileLinkSeq) {
    final accessToken = authController.accessToken;
    final path = ApiConstants.getProfileInfo
        .replaceAll('{profileLinkSeq}', profileLinkSeq.toString());
    dio.interceptors.add(CurlLoggerDioInterceptor(printOnSuccess: true));
    return dio.get(path,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken'
          },
        ));
  }

  static Future<Response> getMyDrugInfo(int profileLinkSeq) {
    final accessToken = authController.accessToken;
    final path = ApiConstants.getMyDrugInfo
        .replaceAll('{profileLinkSeq}', profileLinkSeq.toString());
    dio.interceptors.add(CurlLoggerDioInterceptor(printOnSuccess: true));
    return dio.get(path,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken'
          },
        ));
  }
}
