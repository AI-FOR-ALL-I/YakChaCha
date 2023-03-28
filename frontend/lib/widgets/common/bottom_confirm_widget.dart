import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:frontend/controller/alarm_pill_controller.dart';

class BottomConfirmWidget extends StatelessWidget {
  final bool isAlarm;
  final List? tempList;
  final Function? registerFinal;
  const BottomConfirmWidget({
    Key? key,
    required this.isAlarm,
    this.tempList,
    this.registerFinal,
  }) // Alarm 생성/수정 페이지면 true, 약 선택 화면이면 false
  : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(AlarmPillController());
    return GetBuilder<AlarmPillController>(builder: (controller) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.15,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
              Colors.white.withOpacity(0),
              Colors.white.withOpacity(0.75),
              Colors.white.withOpacity(1),
            ])),
        child: isAlarm
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.alarm_outlined,
                    size: 50,
                  ),
                  Text('알람 설정')
                ],
              )
            : Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                GestureDetector(
                  onTap: () {
                    if (tempList != null) {
                      controller.add(tempList);
                      Navigator.pop(context);
                    } else if (registerFinal != null) {
                      registerFinal!();
                    }
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.check_circle_outlined,
                        size: 50,
                        color: Theme.of(context).colorScheme.background,
                      ),
                      Text('등록')
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.cancel_outlined,
                        size: 50,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      Text('취소')
                    ],
                  ),
                ),
              ]),
      );
    });
  }
}
