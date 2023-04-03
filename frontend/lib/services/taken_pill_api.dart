import 'dart:convert';
import 'dart:io';
import 'package:frontend/controller/auth_controller.dart';
import 'package:frontend/controller/profile_controller.dart';
import 'package:frontend/models/my_pill_model.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class TakenPillApi {
  static const String baseUrl = "https://j8a803.p.ssafy.io/api/profiles";
  static const String taken = "medicine/my?now=false";

  static Future<List<MyPillModel>> getTakenPill() async {
    // controller에 저장된 토큰 불러오는 코드
    final authController = Get.find<AuthController>();
    final token = authController.accessToken;
    print("##################################");
    print('saved accessToken$token');
    final profileController = Get.find<ProfileController>();
    final queryParameters = profileController.profileLinkSeq;
    print('queryParameters$queryParameters');
    print("##################################");
    List<MyPillModel> takenPills = [];
    final url = Uri.parse("$baseUrl/$queryParameters/$taken");
    final response = await http.get(url, headers: {
      HttpHeaders.authorizationHeader: "Bearer $token",
    });
    print("BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB${response.statusCode}");
    if (response.statusCode == 200) {
      print(response.body);
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
