import 'package:flutter/material.dart';
import 'package:frontend/widgets/common/simple_app_bar.dart';
import 'package:frontend/widgets/mypills/my_pill.dart';
import 'package:frontend/widgets/common/bottom_confirm_widget.dart';
import 'package:get/get.dart';
import 'package:frontend/controller/alarm_pill_controller.dart';

class AlarmMyPillPage extends StatefulWidget {
  const AlarmMyPillPage({Key? key}) : super(key: key);

  @override
  State<AlarmMyPillPage> createState() => _AlarmMyPillPageState();
}

class _AlarmMyPillPageState extends State<AlarmMyPillPage> {
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
              Expanded(
                child: ListView.builder(
                    itemCount: 10,
                    itemBuilder: ((context, index) {
                      return GestureDetector(
                        onLongPress: () {
                          setState(() {
                            if (!tempList.contains(index)) {
                              tempList.add(index);
                              print(tempList);
                            } else {
                              tempList.remove(index);
                              print(tempList);
                            }
                          }); // TODO: 리스트의 들어갈 map자료 넣기!!
                        },
                        child: MyPill(
                          isAlarmRegister: false,
                        ),
                      );
                    })),
              )
            ],
          );
        }),
        Positioned(
            bottom: 0,
            child: BottomConfirmWidget(isAlarm: false, tempList: tempList))
      ]),
    );
  }
}
