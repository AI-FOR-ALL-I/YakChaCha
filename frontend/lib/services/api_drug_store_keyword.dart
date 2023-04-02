import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:xml2json/xml2json.dart';

class ApiDrugStoreKeyword {
  static Future getDrugStore(keyword) async {
    const apiKey = "BBtfzEnVsjUygaxKqTzhATnIw3PR2uIILBMWGcxzsspr40fZVpVAe%2Bdw%2F41lxNAUehr9AcxSZetOeqTQw2ZMjg%3D%3D";
    String baseUrl =
        "http://apis.data.go.kr/B551182/pharmacyInfoService/getParmacyBasisList?serviceKey=$apiKey&pageNo=1&numOfRows=10&emdongNm=$keyword&radius=1500";

    final url = Uri.parse(baseUrl);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final xmlData = utf8.decode(response.bodyBytes);
      final xml2json = Xml2Json();
      xml2json.parse(xmlData);
      final jsonData = xml2json.toGData();
      final Map decodedData = jsonDecode(jsonData);
      return decodedData["response"]["body"]["items"]["item"];
    }
    throw Error();
  }
}
