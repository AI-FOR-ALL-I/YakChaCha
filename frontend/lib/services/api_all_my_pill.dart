import 'dart:convert';
import 'dart:io';

import 'package:frontend/models/delete_my_pill_model.dart';
import 'package:frontend/models/my_pill_model.dart';
import 'package:frontend/services/api_constants.dart';
import 'package:http/http.dart' as http;

class ApiAllMyPill {
  static const String baseUrl = "https://j8a803.p.ssafy.io/api/profiles";
  static const String taking = "medicine/my?now=true";
  static const String taken = "medicine/my?now=false";

  static Future<List<DeleteMyPillModel>> getMyAllPill() async {
    const queryParameters = 5;
    const token = ApiConstants.TOKEN;
    List<DeleteMyPillModel> myPills = [];
    final url = Uri.parse("$baseUrl/$queryParameters/$taking");
    final response = await http.get(url, headers: {
      HttpHeaders.authorizationHeader: token,
    });
    if (response.statusCode == 200) {
      final pills = jsonDecode(utf8.decode(response.bodyBytes));
      for (var pill in pills["data"]) {
        final instance = DeleteMyPillModel.fromJson(pill);
        myPills.add(instance);
      }
    } else {
      throw Error();
    }
    final url1 = Uri.parse("$baseUrl/$queryParameters/$taken");
    final response1 = await http.get(url1, headers: {
      HttpHeaders.authorizationHeader: token,
    });
    if (response1.statusCode == 200) {
      final pills = jsonDecode(utf8.decode(response1.bodyBytes));
      for (var pill in pills["data"]) {
        final instance = DeleteMyPillModel.fromJson(pill);
        myPills.add(instance);
      }
      return myPills;
    }
    throw Error();
  }
}
