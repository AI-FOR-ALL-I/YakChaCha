import 'package:flutter/material.dart';
import 'package:xml/xml.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:frontend/services/api_constants.dart';
import 'package:frontend/models/pill_detail_model.dart';

// class DrugStore {
//   String
// }

// https://apis.data.go.kr/B551182/pharmacyInfoService/getParmacyBasisList?serviceKey=BBtfzEnVsjUygaxKqTzhATnIw3PR2uIILBMWGcxzsspr40fZVpVAe%2Bdw%2F41lxNAUehr9AcxSZetOeqTQw2ZMjg%3D%3D&pageNo=1&numOfRows=10&emdongNm=%EC%97%AD%EC%82%BC&radius=1500
// https://apis.data.go.kr/B551182/pharmacyInfoService/getParmacyBasisList?serviceKey=$서비스키&pageNo=1&numOfRows=10&emdongNm=$동네이름&radius=1500

class ApiDrugStore {
  static Future getDrugStore() async {
    String baseUrl =
        "http://apis.data.go.kr/B551182/pharmacyInfoService/getParmacyBasisList?serviceKey=BBtfzEnVsjUygaxKqTzhATnIw3PR2uIILBMWGcxzsspr40fZVpVAe%2Bdw%2F41lxNAUehr9AcxSZetOeqTQw2ZMjg%3D%3D&pageNo=1&numOfRows=10&emdongNm=역삼&radius=1500";

    final url = Uri.parse(baseUrl);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final utfData = utf8.decode(response.bodyBytes);
      XmlDocument document = XmlDocument.parse(utfData);
      XmlElement root = document.rootElement;
      List<String> paragraphs = root
          .findAllElements('PARAGRAPH')
          .map((element) => element.text)
          .toList();
      print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
      print(paragraphs);
      return paragraphs;
    }
    throw Error();
  }
}
