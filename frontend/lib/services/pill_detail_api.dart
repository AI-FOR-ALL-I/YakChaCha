import 'dart:convert';
import 'dart:io';
import 'package:frontend/models/pill_detail_model.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:frontend/controller/auth_controller.dart';
import 'package:frontend/controller/profile_controller.dart';


class PillDetailApi {
  static const String baseUrl = "https://j8a803.p.ssafy.io/api/profiles";
  static const String detail = "medicine/detail";

  static Future getPillDetail(pillNum) async {
    // controller에 저장된 토큰 불러오는 코드
    final authController = Get.find<AuthController>();
    final token = authController.accessToken;
    // print('saved accessToken$accessToken');
    final profileController = Get.find<ProfileController>();
    final queryParameters = profileController.profileLinkSeq;
    final url = Uri.parse("$baseUrl/$queryParameters/$detail/$pillNum");
    final response = await http.get(url, headers: {
      HttpHeaders.authorizationHeader: "Bearer $token",
    });

    if (response.statusCode == 200) {
      final utfData = utf8.decode(response.bodyBytes);

      final jsonData = jsonDecode(utfData);

      final ans = PillDetailModel.fromJson(jsonData["data"]);

      return ans;
    }
    throw Error();
  }
}
