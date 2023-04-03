import 'dart:convert';
import 'dart:io';

import 'package:frontend/models/my_pill_model.dart';
import 'package:frontend/services/api_constants.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:frontend/controller/auth_controller.dart';
import 'package:frontend/controller/profile_controller.dart';

class MyPillApi {
  static const String baseUrl = "https://j8a803.p.ssafy.io/api/profiles";
  static const String taking = "medicine/my?now=true";

  static Future<List<MyPillModel>> getMyPill() async {
    // controller에 저장된 토큰 불러오는 코드
    final authController = Get.find<AuthController>();
    final token = authController.accessToken;
    final profileController = Get.find<ProfileController>();
    final queryParameters = profileController.profileLinkSeq;
    List<MyPillModel> myPills = [];
    final url = Uri.parse("$baseUrl/$queryParameters/$taking");
    final response = await http.get(url, headers: {
      HttpHeaders.authorizationHeader: "Bearer $token",
    });
    if (response.statusCode == 200) {
      final pills = jsonDecode(utf8.decode(response.bodyBytes));
      for (var pill in pills["data"]) {
        final instance = MyPillModel.fromJson(pill);
        myPills.add(instance);
      }
      return myPills;
    }
    throw Error();
  }
}
