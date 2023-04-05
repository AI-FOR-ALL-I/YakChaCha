import 'package:flutter/material.dart';
import 'package:frontend/widgets/common/simple_app_bar.dart';
import 'package:frontend/widgets/mypills/my_pill_for_alarm_register.dart';
import 'package:frontend/widgets/mypills/renew_my_pill.dart';
import 'package:frontend/services/my_pill_api.dart';
import 'package:frontend/widgets/common/bottom_confirm_widget.dart';
import 'package:get/get.dart';
import 'package:frontend/controller/alarm_pill_controller.dart';
import 'package:frontend/models/my_pill_model.dart';
import 'package:frontend/screens/pill_details/pill_details_for_api.dart';

class AlarmMyPillPage extends StatefulWidget {
  const AlarmMyPillPage({Key? key}) : super(key: key);

  @override
  State<AlarmMyPillPage> createState() => _AlarmMyPillPageState();
}

class _AlarmMyPillPageState extends State<AlarmMyPillPage> {
  final Future myPills = MyPillApi.getMyPill();

  @override
  Widget build(BuildContext context) {
    Get.put(AlarmPillController());
    var tempList = Get.find<AlarmPillController>().selectedList;
    return Scaffold(
      appBar: SimpleAppBar(title: '복약 목록 선택'),
      body: Stack(children: [
        GetBuilder<AlarmPillController>(builder: (controller) {
          return Column(
            children: [
              Text('등록된 약 목록'),
              Flexible(
                  flex: 25,
                  child: FutureBuilder(
                    future: myPills,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        Get.find<AlarmPillController>()
                            .saveMyPill(snapshot.data!);
                        return myPillList(snapshot);
                      } else {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  ))
            ],
          );
        }),
        Positioned(
            bottom: 0,
            child: BottomConfirmWidget(isAlarm: false, isAlarmMyPill: true))
      ]),
    );
  }
}

Column myPillList(AsyncSnapshot snapshot) {
  return Column(
    children: [
      Flexible(
        flex: 1,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
          child: Container(
            alignment: Alignment.centerLeft,
            child: Text(
              "총 ${snapshot.data!.length.toString()}건",
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
      ),
      Flexible(
        flex: 24,
        child: ListView.separated(
          itemCount: snapshot.data!.length,
          separatorBuilder: (context, index) => SizedBox(),
          itemBuilder: (context, index) {
            var pill = snapshot.data![index];
            return GetBuilder<AlarmPillController>(builder: (controller) {
              bool isSelected = controller.tempList.contains(pill.itemSeq);
              return GestureDetector(
                onTap: () {
                  print("here");
                  controller.selectTemp(pill.itemSeq);
                },
                onLongPress: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PillDetailsForApi(
                              turnOnPlus: false,
                              isRegister: false,
                              num: pill.itemSeq.toString())));
                }, // TODO 상세페이지로 가도록
                child: Container(
                  child: AbsorbPointer(
                    child: RenewMyPill(
                        itemSeq: pill.itemSeq,
                        itemName: pill.itemName,
                        img: pill.img,
                        tag_list: pill.tagList,
                        isTaken: false,
                        dday: pill.dday,
                        isSelected: isSelected),
                  ),
                ),
              );
            });
          },
        ),
      ),
      SizedBox(
        height: 100,
      )
    ],
  );
}
