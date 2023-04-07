import 'package:flutter/material.dart';
import 'package:frontend/controller/alarm_controller.dart';
import 'package:frontend/controller/profile_controller.dart';
import 'package:frontend/models/get_news_model.dart';
import 'package:frontend/services/api_get_news.dart';
import 'package:frontend/services/api_profiles.dart';
import 'package:frontend/widgets/common/is_empty_pills.dart';
import 'package:frontend/widgets/main/eat_check_button.dart';
import 'package:frontend/widgets/main/health_tip_item.dart';
import 'package:frontend/widgets/main/my_drug_item.dart';
import 'package:frontend/widgets/main/time_header.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  // 메인 페이지 진입시 푸시알림 여부 확인
  getPermission() async {
    var status = await Permission.notification.status;
    if (status.isGranted) {
      print('허락됨');
    } else if (status.isDenied) {
      print('거절됨');
      Permission.notification.request();
    }
    if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  List<Map<String, dynamic>> drugs = [];
  Map<String, dynamic> profileInfo = {};
  int formattedTime = 0;
  int timeline = 0;
  DateTime currentTime = DateTime.now();
  List alarms = [];
  Map nearAlarm = {};
  String refTime = '';
  @override
  void initState() {
    super.initState();
    getPermission();

    //var profileController = Get.put(ProfileController());

    //print('profile인덱스확인${profileController.profileLinkSeq}');
    getUserInfo();
    getDrugInfo();
    getAlarmList();
    //print('profile인덱스확인 end${profileController.profileLinkSeq}');
    formattedTime = int.parse(DateFormat('HH').format(currentTime));
    refTime = DateFormat('HH:mm').format(currentTime);
    if (6 <= formattedTime && formattedTime < 12) {
      timeline = 0;
    } else if (12 <= formattedTime && formattedTime < 19) {
      timeline = 1;
    } else {
      timeline = 2;
    }
  }

  var controller = Get.put(AlarmController());
  getAlarmList() async {
    await controller.getAlarmList();
    alarms = controller.alarmList;
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
    final Future<List<GetNewsModel>> todayNews = ApiGetNews.getNews();

    if (controller.alarmList.isNotEmpty) {
      for (var i = 0; i < controller.alarmList.length; i++) {
        if (controller.alarmList[i]['status'] == 3) {
          nearAlarm = controller.alarmList[i];
        }
      }
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Scaffold(
        body: Column(
          children: [
            TimeHeader(
              nickname: profileInfo['nickname'] ?? '',
              timeline: timeline,
            ),
            Expanded(
                child: MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: ListView(
                children: [
                  nearAlarm.isNotEmpty
                      ? Column(children: [
                          Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(15.0),
                                child: Text(
                                  "약 먹어야하는 시간",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16.0),
                                ),
                              ),
                              Icon(Icons.schedule, size: 20.0),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 5.0),
                                child: Text(
                                  // TODO: 다음 알람의 시간으로 대체 해야함
                                  nearAlarm["time"],
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16.0),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.all(10.0),
                            child: EatCheckButton(
                              data: nearAlarm,
                            ),
                          ),
                        ])
                      : SizedBox(),
                  const Padding(
                    padding: EdgeInsetsDirectional.symmetric(
                        horizontal: 15.0, vertical: 15.0),
                    child: Text(
                      "내 약 목록",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 16.0),
                    ),
                  ),
                  SizedBox(
                    height: 220,
                    child: drugs.isNotEmpty
                        ? ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: drugs.length,
                            itemBuilder: (BuildContext context, int index) {
                              final item = drugs[index];
                              return MyDrugItem(
                                imagePath: item["img"],
                                title: item['itemName'],
                                tag_list: item['tagList'],
                                itemSeq: item['itemSeq'],
                              );
                            })
                        : const IsEmptyPills(what: "알약"),
                  ),
                  const Padding(
                    padding: EdgeInsetsDirectional.symmetric(
                        horizontal: 15.0, vertical: 15.0),
                    child: Text(
                      "오늘의 건강 상식",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 16.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 8.0),
                    child: SizedBox(
                      width: 300,
                      height: 290,
                      child: FutureBuilder(
                        future: todayNews,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return newsList(snapshot);
                          } else {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                        },
                      ),
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

ListView newsList(AsyncSnapshot<List<GetNewsModel>> snapshot) {
  var news = snapshot.data!;
  return ListView.separated(
      separatorBuilder: (context, index) => const SizedBox(width: 10),
      scrollDirection: Axis.horizontal,
      itemCount: news.length,
      itemBuilder: (context, index) {
        return HealthTipItem(
            url: news[index].url,
            img: news[index].img,
            title: news[index].title,
            description: news[index].description);
      });
}
