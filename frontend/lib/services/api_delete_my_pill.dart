import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:frontend/controller/auth_controller.dart';
import 'package:frontend/controller/profile_controller.dart';

class ApiDeleteMyPill {
  static const String baseUrl = "https://j8a803.p.ssafy.io/api/profiles";
  static const String what = "medicine/my?myMedicineSeq=";

  static getPillDetail(myMedicineSeq) async {
    // controller에 저장된 토큰 불러오는 코드
    final authController = Get.find<AuthController>();
    final token = authController.refreshToken;
    // print('saved accessToken$accessToken');
    final profileController = Get.find<ProfileController>();
    final queryParameters = profileController.profileLinkSeq;
    final url = Uri.parse("$baseUrl/$queryParameters/$what$myMedicineSeq");
    final response = await http.put(url, headers: {
      HttpHeaders.authorizationHeader: "Bearer $token",
    });

    if (response.statusCode == 200) {
      return true;
    }
    throw Error();
  } 
}
