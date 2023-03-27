import 'dart:convert';

import 'package:frontend/models/my_pill_model.dart';
import 'package:http/http.dart' as http;


class MyPillApi {
  static const String baseUrl = "http://localhost:3001/medicine";
  static const String taking = "taking";

  static Future<List<MyPillModel>> getMyPill() async {
    List<MyPillModel> myPills = [];
    final url = Uri.parse("$baseUrl/$taking");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> pills = jsonDecode(response.body);
      for (var pill in pills) {
        final instance = MyPillModel.fromJson(pill);
        myPills.add(instance);
      }
      return myPills;
    }
    throw Error();
  }
}
