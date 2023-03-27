// import 'dart:convert';

// import 'package:frontend/models/pill_detail_model.dart';
// import 'package:http/http.dart' as http;

// class MyPillApi {
//   static const String baseUrl = "http://localhost:3001/medicine";
//   static const String detail = "detail";

//   static Future<List<PillDetailModel>> getMyPill(pillNum) async {
//     List<PillDetailModel> pillDetails = [];
//     final url = Uri.parse("$baseUrl/$detail/$pillNum");
//     final response = await http.get(url);
//     if (response.statusCode == 200) {
//       pillDetails = jsonDecode(response.body).map<PillDetailModel>(return pillDetails).toList();
//     }
//     throw Error();
//   }
// }
