import 'package:flutter/material.dart';
import 'package:frontend/services/api_profiles.dart';
import 'package:frontend/widgets/profile/profile_info.dart';
import 'package:frontend/widgets/common/simple_app_bar.dart';
import 'package:dio/dio.dart';

class SelectProfilePage extends StatefulWidget {
  const SelectProfilePage({super.key});

  @override
  _SelectProfilePage createState() => _SelectProfilePage();
}

class _SelectProfilePage extends State<SelectProfilePage> {
  List<Map<String, dynamic>> data = [];

  final dio = Dio();

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    try {
      Response response = await ApiProfiles.getMultiProfiles();
      if (response.statusCode == 200) {
        final List<Map<String, dynamic>> newData =
            List<Map<String, dynamic>>.from(response.data['data']);
        setState(() {
          data = newData;
          print('data$data');
        });
      } else {
        // 오류처리
      }
    } catch (e) {
      // 오류 처리
    }
  }

  // item['nickname']
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const SimpleAppBar(title: '프로필 선택'),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (BuildContext context, int index) {
                  final item = data[index];
                  return ProfileInfo(
                      owner: item['owner'],
                      nickname: item['nickname'],
                      name: item['name'],
                      birthDate: item['birthDate'],
                      gender: item['gender'],
                      imageCode: item['imgCode'],
                      profileLinkSeq: item['profileLinkSeq']);
                })));
  }
}
