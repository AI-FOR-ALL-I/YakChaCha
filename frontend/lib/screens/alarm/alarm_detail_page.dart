import 'package:flutter/material.dart';
import 'package:frontend/widgets/mypills/my_pill_for_alarm_register.dart';
import 'package:frontend/widgets/common/simple_app_bar.dart';
import 'package:frontend/widgets/common/tag_widget.dart';
import 'package:frontend/screens/alarm/alarm_create_page.dart';
import 'package:frontend/widgets/mypills/renew_my_pill.dart';
import 'package:frontend/controller/alarm_controller.dart';
import 'package:get/get.dart';

class AlarmDetailPage extends StatefulWidget {
  const AlarmDetailPage({Key? key}) : super(key: key);

  @override
  State<AlarmDetailPage> createState() => _AlarmDetailPageState();
}

class _AlarmDetailPageState extends State<AlarmDetailPage> {
  @override // 알람 디테일 받아오기
  void initState() {
    super.initState();
    var controller = Get.put(AlarmController());
    controller.getAlarmDetail(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(title: '알람 설정'),
      body: GetBuilder<AlarmController>(builder: (controller) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(15)),
                child: AspectRatio(
                  aspectRatio: 311 / 118,
                  child: Stack(
                    children: [
                      Container(
                          child: Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(controller.alarmDetail != null &&
                                        controller.alarmDetail['title'] != null
                                    ? controller.alarmDetail["title"]
                                    : "복약 알람!"),
                              ],
                            ),
                            Row(
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                textBaseline: TextBaseline.alphabetic,
                                children: [
                                  Text(
                                    controller.alarmDetail != null
                                        ? '${controller.alarmDetail["time"].split(':')[0]}:${controller.alarmDetail["time"].split(':')[1]}'
                                        : '00',
                                    style: TextStyle(fontSize: 40),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text(
                                      controller.alarmDetail != null
                                          ? controller.alarmDetail["time"]
                                              .split(':')[2]
                                          : '00',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                  )
                                ]),
                          ],
                        ),
                      )),
                      Align(
                          alignment: AlignmentDirectional.topEnd,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            AlarmCreatePage(isCreate: false)));
                              },
                              icon: Icon(Icons.settings_outlined),
                            ),
                          ))
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
                child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30)),
                  color: Theme.of(context).colorScheme.primary),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(controller.alarmDetail != null
                        ? '총 ${controller.alarmDetail['totalCount']}정 | ${controller.alarmDetail['typeCount']} 종류'
                        : '로딩중'),
                  ),
                  Expanded(
                    child: controller.alarmDetail != null
                        ? ListView.builder(
                            itemCount:
                                controller.alarmDetail['medicineList'].length,
                            // shrinkWrap: true,
                            itemBuilder: ((context, i) {
                              var pill =
                                  controller.alarmDetail["medicineList"][i];
                              return RenewMyPill(
                                itemSeq: pill["medicineSeq"],
                                itemName: pill["name"],
                                img: pill["img"],
                                tag_list: pill["tagList"],
                                isTaken: false,
                                dday: pill.dday,
                              );
                            }))
                        : SizedBox(),
                  )
                ],
              ),
            ))
          ],
        );
      }),
    );
  }
}
