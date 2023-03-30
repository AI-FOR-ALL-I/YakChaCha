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

class ApiTag {
  // 태그 목록 조회
  static Future<Response> getTagList() async {
    return dio.get(
      ApiConstants.getTagList,
      options: Options(headers: {
        'Content-Type': 'application/json',
        'Authorization': ApiConstants.TOKEN
      }),
    );
  }

  // 태그로 약 조회
  static Future<Response> getPillsFromTag(List data) async {
    return dio.get(
      ApiConstants.getPillsFromTag,
      options: Options(headers: {
        'Content-Type': 'application/json',
        'Authorization': ApiConstants.TOKEN
      }),
    );
  }
}
