import 'package:dio/dio.dart';
import 'package:frontend/controller/profile_controller.dart';
import 'package:frontend/controller/auth_controller.dart';
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
final tempProfileLinkSeq = controller.profileLinkSeq;
final accessToken = authController.accessToken;

class ApiSearch {
  // 텍스트로 검색
  static Future<Response> textSearch(String word) async {
    final path = ApiConstants.search
        .replaceAll('{profileLinkSeq}', tempProfileLinkSeq.toString());
    return dio.get(path,
        queryParameters: {'type': 'text', 'query': word},
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}));
  }

  // 여기가 사진으로 검색
  static Future<Response> imgSearch(data) async {
    final path = ApiConstants.imgSearch
        .replaceAll('{profileLinkSeq}', tempProfileLinkSeq.toString());
    return dio.post(path,
        data: data,
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}));
  }

  // 여기가 사진으로 검색 후 약 디테일 받아오는 dio
  static Future<Response> imgSearchFinal(List data) async {
    final path = ApiConstants.search
        .replaceAll('{profileLinkSeq}', tempProfileLinkSeq.toString());
    return dio.get(path,
        queryParameters: {'type': 'img', 'query': data},
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}));
  }

  // 처방전으로 검색
  static Future<Response> ocrSearch(data) async {
    final path = ApiConstants.ocrSearch
        .replaceAll('{profileLinkSeq}', tempProfileLinkSeq.toString());
    return dio.post(path,
        data: data,
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}));
  }

  // OCR 마지막
  static Future<Response> ocrSearchFinal(List data) async {
    final path = ApiConstants.search
        .replaceAll('{profileLinkSeq}', tempProfileLinkSeq.toString());
    return dio.get(path,
        queryParameters: {'type': 'paper', 'query': data},
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}));
  }
}
