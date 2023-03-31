import 'dart:convert';
import 'dart:io';

import 'package:frontend/models/my_pill_model.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/services/api_constants.dart';

class TakenPillApi {
  static const String baseUrl = "https://j8a803.p.ssafy.io/api/profiles";
  static const String taken = "medicine/my?now=false";

  static Future<List<MyPillModel>> getTakenPill() async {
    // controller에 저장된 토큰 불러오는 코드
    // final authController = Get.find<AuthController>();
    // final accessToken = authController.accessToken;
    // print('saved accessToken$accessToken');
    const queryParameters = 5;
    // 토큰 불러오는 부분
    const token = ApiConstants.TOKEN;
    List<MyPillModel> takenPills = [];
    final url = Uri.parse("$baseUrl/$queryParameters/$taken");
    final response = await http.get(url, headers: {
      HttpHeaders.authorizationHeader: token,
    });
    print(response.statusCode);
    print(response.body);
    print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
    if (response.statusCode == 200) {
      final pills = jsonDecode(utf8.decode(response.bodyBytes));
      for (var pill in pills["data"]) {
        final instance = MyPillModel.fromJson(pill);
        takenPills.add(instance);
      }
      return takenPills;
    }
    throw Error();
  }
}
