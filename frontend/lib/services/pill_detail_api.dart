import 'dart:convert';
import 'dart:io';
import 'package:frontend/services/api_constants.dart';
import 'package:frontend/models/pill_detail_model.dart';
import 'package:http/http.dart' as http;

class PillDetailApi {
  static const String baseUrl = "https://j8a803.p.ssafy.io/api/profiles";
  static const String detail = "medicine/detail";

  static Future<PillDetailModel> getPillDetail(pillNum) async {
    const profileNum = 1;
    const token = ApiConstants.TOKEN;
    final url = Uri.parse("$baseUrl/$profileNum/$detail/$pillNum");
    final response = await http.get(url, headers: {
      HttpHeaders.authorizationHeader: token,
    });
    print(response.statusCode);
    if (response.statusCode == 200) {
      final utfData = utf8.decode(response.bodyBytes);
      print('utfData: $utfData');
      final jsonData = jsonDecode(utfData);
      print('jsonData: $jsonData');
      final ans = PillDetailModel.fromJson(jsonData["data"]);
      print('ans: $ans');
      return ans;
    }
    throw Error();
  }
}
