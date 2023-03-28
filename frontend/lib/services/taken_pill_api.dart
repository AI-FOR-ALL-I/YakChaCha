import 'dart:convert';

import 'package:frontend/models/my_pill_model.dart';
import 'package:http/http.dart' as http;


class TakenPillApi {
  static const String baseUrl = "http://10.0.2.2:3001";
  static const String taking = "medicineTaken";

  static Future<List<MyPillModel>> getTakenPill() async {
    List<MyPillModel> takenPills = [];
    final url = Uri.parse("$baseUrl/$taking");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> pills = jsonDecode(response.body);
      for (var pill in pills) {
        final instance = MyPillModel.fromJson(pill);
        takenPills.add(instance);
      }
      return takenPills;
    }
    throw Error();
  }
}
