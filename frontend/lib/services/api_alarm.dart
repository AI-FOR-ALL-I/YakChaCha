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

class ApiAlarm {
  static Future<Response> getAlarmList() async {
    return dio.get(
      ApiConstants.getAlarm,
      options: Options(headers: {
        'Content-Type': 'application/json',
        'Authorization': ApiConstants.TOKEN
      }),
    );
  }

  static Future<Response> getAlarmDetail(int alarmSeq) async {
    return dio.get(
      ApiConstants.getAlarm + '/${alarmSeq}',
      options: Options(headers: {
        'Content-Type': 'application/json',
        'Authorization': ApiConstants.TOKEN
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