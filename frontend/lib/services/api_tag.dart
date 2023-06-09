import 'package:dio/dio.dart';
import 'package:frontend/controller/auth_controller.dart';
import 'package:frontend/controller/profile_controller.dart';
import 'api_constants.dart';
import 'package:curl_logger_dio_interceptor/curl_logger_dio_interceptor.dart';
import 'package:get/get.dart' as getX;

final dio = Dio(
  BaseOptions(
    baseUrl: ApiConstants.baseurl,
  ),
);

final controller = getX.Get.find<ProfileController>();
final authController = getX.Get.find<AuthController>();
var tempProfileLinkSeq = controller.profileLinkSeq;
var accessToken = authController.accessToken;

// 알약 등록

class ApiTag {
  // 태그 목록 조회
  static Future<Response> getTagList() async {
    tempProfileLinkSeq = controller.profileLinkSeq;
    accessToken = authController.accessToken;
    final path = ApiConstants.getTagList
        .replaceAll('{profileLinkSeq}', tempProfileLinkSeq.toString());
    return dio.get(
      path,
      options: Options(headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      }),
    );
  }

  // 태그로 약 조회
  static Future<Response> getPillsFromTag(List data) async {
    tempProfileLinkSeq = controller.profileLinkSeq;
    accessToken = authController.accessToken;
    final path = ApiConstants.getPillsFromTag
        .replaceAll('{profileLinkSeq}', tempProfileLinkSeq.toString());
    return dio.post(path,
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken'
        }),
        data: data);
  }
}
