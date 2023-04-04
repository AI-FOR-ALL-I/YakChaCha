import 'package:dio/dio.dart';
import 'package:frontend/controller/auth_controller.dart';
import 'api_constants.dart';
import 'package:curl_logger_dio_interceptor/curl_logger_dio_interceptor.dart';
import 'package:get/get.dart' as getX;
import 'package:frontend/controller/profile_controller.dart';

final controller = getX.Get.find<ProfileController>();
final authController = getX.Get.find<AuthController>();
final tempProfileLinkSeq = controller.profileLinkSeq;
final accessToken = authController.accessToken;

final dio = Dio(
  BaseOptions(
    baseUrl: ApiConstants.baseurl,
  ),
);

// 알약 등록

class ApiPillRegister {
  static Future<Response> pillRegister(List data) async {
    dio.interceptors.add(CurlLoggerDioInterceptor(printOnSuccess: true));
    final path = ApiConstants.pillRegister
        .replaceAll('{profileLinkSeq}', tempProfileLinkSeq.toString());
    return dio.post(path,
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken'
        }),
        data: data);
  }
}
