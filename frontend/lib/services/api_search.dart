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

class ApiSearch {
  // 텍스트로 검색
  static Future<Response> textSearch(String word) async {
    dio.interceptors.add(CurlLoggerDioInterceptor(printOnSuccess: true));
    return dio.get(ApiConstants.search,
        queryParameters: {'type': 'text', 'query': word},
        options: Options(headers: {'Authorization': ApiConstants.TOKEN}));
  }

  // 여기가 사진으로 검색
  static Future<Response> imgSearch(data) async {
    return dio.post(ApiConstants.imgSearch,
        data: data,
        options: Options(headers: {'Authorization': ApiConstants.TOKEN}));
  }

  // 여기가 사진으로 검색 후 약 디테일 받아오는 dio
  static Future<Response> imgSearchFinal(List data) async {
    return dio.get(ApiConstants.search,
        queryParameters: {'type': 'img', 'query': data},
        options: Options(headers: {'Authorization': ApiConstants.TOKEN}));
  }

  // 처방전으로 검색
  static Future<Response> ocrSearch(data) async {
    dio.interceptors.add(CurlLoggerDioInterceptor(printOnSuccess: true));
    return dio.post(ApiConstants.ocrSearch,
        data: data,
        options: Options(headers: {'Authorization': ApiConstants.TOKEN}));
  }

  // OCR 마지막
  static Future<Response> ocrSearchFinal(List data) async {
    dio.interceptors.add(CurlLoggerDioInterceptor(printOnSuccess: true));
    return dio.get(ApiConstants.search,
        queryParameters: {'type': 'paper', 'query': data},
        options: Options(headers: {'Authorization': ApiConstants.TOKEN}));
  }
}
