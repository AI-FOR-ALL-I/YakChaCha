import 'dart:convert';

import 'package:frontend/models/pill_detail_model.dart';
import 'package:http/http.dart' as http;

class PillDetailApi {
  static const String baseUrl = "http://localhost:3001/medicine";
  static const String detail = "detail";

  static Future<PillDetailModel> getPillDetail(pillNum) async {
    final url = Uri.parse("$baseUrl$detail$pillNum");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return PillDetailModel.fromJson(json.decode(response.body));
    }
    throw Error();
  }
}
