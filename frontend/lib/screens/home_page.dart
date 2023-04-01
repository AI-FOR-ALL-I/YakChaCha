import 'package:flutter/material.dart';
import 'package:frontend/controller/profile_controller.dart';
import 'package:frontend/services/api_profiles.dart';
import 'package:frontend/widgets/main/eat_check_button.dart';
import 'package:frontend/widgets/main/health_tip_item.dart';
import 'package:frontend/widgets/main/my_drug_item.dart';
import 'package:frontend/widgets/main/time_header.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePage createState() => _HomePage();
}

/*
{
    "success": true,
    "message": "요청에 성공하셨습니다.",
    "data": {
        "profileLinkSeq": 2,
        "imgCode": 1,
        "nickname": "nickyoonjin",
        "name": "yoondin",
        "gender": "F",
        "birthDate": "1998-12-14",
        "pregnancy": false,
        "owner": true
    }
}
 */
class _HomePage extends State<HomePage> {
  List<Map<String, dynamic>> drugs = [];
  Map<String, dynamic> profileInfo = {};
  @override
  void initState() {
    super.initState();
    getUserInfo();
    getDrugInfo();
  }

  void getDrugInfo() async {
    final profileController = Get.find<ProfileController>();
    final profileLinkSeq = profileController.profileLinkSeq;
    try {
      dio.Response response = await ApiProfiles.getMyDrugInfo(profileLinkSeq);
      if (response.statusCode == 200) {
        final List<Map<String, dynamic>> newData =
            List<Map<String, dynamic>>.from(response.data['data']);
        setState(() {
          drugs = newData;
        });
      } else {
        // 오류처리
      }
    } catch (e) {
      e.printError(info: 'errors');
    }
  }

  void getUserInfo() async {
    // 헤더부분에 보여지는 내 이름
    final profileController = Get.find<ProfileController>();
    final profileLinkSeq = profileController.profileLinkSeq;
    print('profilelink$profileLinkSeq');
    try {
      dio.Response response = await ApiProfiles.getProfileInfo(profileLinkSeq);
      if (response.statusCode == 200) {
        final Map<String, dynamic> newData =
            Map<String, dynamic>.from(response.data['data']);
        setState(() {
          profileInfo = newData;
        });
      }
    } catch (e) {
      e.printError(info: 'errors');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Scaffold(
        body: Column(
          children: [
            TimeHeader(
              nickname: profileInfo['nickname'] ?? '',
              timeline: 0,
            ),
            Expanded(
                child: MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: ListView(
                children: [
                  Row(
                    children: const [
                      Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Text(
                          "약 먹어야하는 시간",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 16.0),
                        ),
                      ),
                      Icon(Icons.schedule, size: 20.0),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 5.0),
                        child: Text(
                          "17:00",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 16.0),
                        ),
                      ),
                    ],
                  ),
                  // 시간 다가오는지 여부에 따라 활성화?
                  const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: EatCheckButton(),
                  ),

                  const Padding(
                    padding: EdgeInsetsDirectional.symmetric(
                        horizontal: 15.0, vertical: 15.0),
                    child: Text(
                      "내 약 목록",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 16.0),
                    ),
                  ),
                  SizedBox(
                    height: 150,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: drugs.length,
                        itemBuilder: (BuildContext context, int index) {
                          final item = drugs[index];
                          print('item$item');
                          if (item.isEmpty) {
                            return Container(child: const Text('비어있음....'));
                          } else {
                            return MyDrugItem(
                                imagePath: 'assets/images/night.png',
                                title: item['itemName']);
                          }
                        }),
                  ),
                  const Padding(
                    padding: EdgeInsetsDirectional.symmetric(
                        horizontal: 15.0, vertical: 15.0),
                    child: Text(
                      "상식 어쩌구",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 16.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 8.0),
                    child: SizedBox(
                      width: 300,
                      height: 290,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 5,
                          itemBuilder: (BuildContext context, int index) {
                            return const HealthTipItem();
                          }),
                    ),
                  )
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }
}
