import 'dart:convert';
import 'dart:io';

import 'package:frontend/models/my_pill_model.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/services/api_constants.dart';

class TakenPillApi {
  static const String baseUrl = "https://j8a803.p.ssafy.io/api";
  // static const String taken = "medicine/taken?profileLinkSeq=";
  static const String taken = "medicine/taking?profileLinkSeq=";

  static Future<List<MyPillModel>> getTakenPill() async {
    const queryParameters = 1;
    const token = ApiConstants.TOKEN;
    List<MyPillModel> takenPills = [];
    final url = Uri.parse("$baseUrl/$taken$queryParameters");
    final response = await http.get(url, headers: {
      HttpHeaders.authorizationHeader: token,
    });
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
