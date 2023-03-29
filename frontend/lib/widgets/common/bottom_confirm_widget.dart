import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:frontend/controller/alarm_pill_controller.dart';
import 'package:frontend/screens/drug_history_page.dart';
import 'dart:async';

class BottomConfirmWidget extends StatelessWidget {
  final bool isAlarm;
  final List? tempList;
  final Function? registerFinal;
  final Function? confirm;
  const BottomConfirmWidget({
    Key? key,
    required this.isAlarm,
    this.tempList,
    this.registerFinal,
    this.confirm,
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
                  onTap: () async {
                    if (confirm != null) {
                      var temp = await confirm!();
                      if (temp) {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('성공적으로 등록되었습니다!'),
                              content: Text('3초 뒤에 메인화면으로 이동합니다~'),
                            );
                          },
                        );

// 3초 후에 다이얼로그를 닫음
                        Timer(Duration(seconds: 3), () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                          // Navigator.of(context).push(MaterialPageRoute(
                          //     builder: (context) =>
                          //         DrugHistoryPage())); //하니까 엄청 꺠짐....
                        });
                      }
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
