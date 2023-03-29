import 'dart:convert';
import 'dart:io';

import 'package:frontend/models/my_pill_model.dart';
import 'package:frontend/services/api_constants.dart';
import 'package:http/http.dart' as http;

class MyPillApi {
  static const String baseUrl = "https://j8a803.p.ssafy.io/api/profiles";
  static const String taking = "medicine/my?now=true";
  // static const String taking = "medicine/taking?profileLinkSeq=";

  static Future<List<MyPillModel>> getMyPill() async {
    const queryParameters = 1;
    const token = ApiConstants.TOKEN;
    List<MyPillModel> myPills = [];
    final url = Uri.parse("$baseUrl/$queryParameters/$taking");
    final response = await http.get(url, headers: {
      HttpHeaders.authorizationHeader: token,
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
