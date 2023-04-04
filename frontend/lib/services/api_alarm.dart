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
final tempProfileLinkSeq = controller.profileLinkSeq;
final accessToken = authController.accessToken;

// 알약 등록

class ApiAlarm {
  static Future<Response> getAlarmList() async {
    final path = ApiConstants.getAlarm
        .replaceAll('{profileLinkSeq}', tempProfileLinkSeq.toString());
    return dio.get(
      path,
      options: Options(headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      }),
    );
  }

  static Future<Response> getAlarmDetail(int alarmSeq) async {
    print('시작!');
    dio.interceptors.add(CurlLoggerDioInterceptor(printOnSuccess: true));
    final path = ApiConstants.getAlarm
        .replaceAll('{profileLinkSeq}', tempProfileLinkSeq.toString());
    return dio.get(
      path + '/${alarmSeq}',
      options: Options(headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      }),
    );
    print('끝');
  }

  static Future<Response> getAlarmCalendar(int alarmSeq, String yyyyMM) async {
    final path = ApiConstants.getAlarm
        .replaceAll('{profileLinkSeq}', tempProfileLinkSeq.toString());
    return dio.get(
      path + '/${alarmSeq}/records/$yyyyMM',
      options: Options(headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      }),
    );
  }

  static Future<Response> takePills(int alarmSeq) async {
    final path = ApiConstants.getAlarm
        .replaceAll('{profileLinkSeq}', tempProfileLinkSeq.toString());
    return dio.put(
      path + '/${alarmSeq}/take',
      options: Options(headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      }),
    );
  }
}


// // 호출방법은 아래와 같은 방법인듯.
//   /*
//   Future<void> fetchUsers() async {
//   try {
//     Response response = await ApiClient.getUsers();
//     // handle response data
//   } catch (e) {
//     // handle error
//   }
// }