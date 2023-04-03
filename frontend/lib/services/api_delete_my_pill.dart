import 'dart:io';
import 'package:frontend/services/api_constants.dart';
import 'package:http/http.dart' as http;

class ApiDeleteMyPill {
  static const String baseUrl = "https://j8a803.p.ssafy.io/api/profiles";
  static const String what = "medicine/my?myMedicineSeq=";

  static getPillDetail(myMedicineSeq) async {
    const profileNum = 5;
    const token = ApiConstants.TOKEN;
    final url = Uri.parse("$baseUrl/$profileNum/$what$myMedicineSeq");
    final response = await http.put(url, headers: {
      HttpHeaders.authorizationHeader: token,
    });

    if (response.statusCode == 200) {
      return true;
    }
    throw Error();
  } 
}
