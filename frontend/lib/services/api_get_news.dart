import 'dart:convert';
import 'dart:io';
import 'package:frontend/models/get_news_model.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:frontend/controller/auth_controller.dart';

class ApiGetNews {
  static const String baseUrl = "https://j8a803.p.ssafy.io/api/news";

  static Future<List<GetNewsModel>> getNews() async {
    // controller에 저장된 토큰 불러오는 코드
    final authController = Get.find<AuthController>();
    final token = authController.accessToken;
    final url = Uri.parse(baseUrl);
    final response = await http.get(url, headers: {
      HttpHeaders.authorizationHeader: "Bearer $token",
    });
    List<GetNewsModel> news = [];
    if (response.statusCode == 200) {
      final newsDatas = jsonDecode(utf8.decode(response.bodyBytes));

      for (var newsData in newsDatas["data"]) {
        final instance = GetNewsModel.fromJson(newsData);
        news.add(instance);
      }
      return news;
    }
    throw Error();
  }
}
