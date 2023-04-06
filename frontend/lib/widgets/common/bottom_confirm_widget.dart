import 'package:flutter/material.dart';
import 'package:frontend/bottom_navigation.dart';
import 'package:get/get.dart';
import 'package:frontend/controller/alarm_pill_controller.dart';
import 'package:frontend/controller/alarm_controller.dart';
import 'dart:async';
import 'package:confirm_dialog/confirm_dialog.dart';

class BottomConfirmWidget extends StatefulWidget {
  final bool isAlarm;
  final bool? isAlarmUpdate;
  final List? tempList;
  final Function? registerFinal;
  final Function? confirm;
  final bool isAlarmMyPill;
  final int? reminderSeq;

  const BottomConfirmWidget(
      {Key? key,
      required this.isAlarm,
      this.tempList,
      this.registerFinal,
      this.confirm,
      this.isAlarmUpdate,
      required this.isAlarmMyPill,
      this.reminderSeq}) // Alarm 생성/수정 페이지면 true, 약 선택 화면이면 false
      : super(key: key);

  @override
  State<BottomConfirmWidget> createState() => _BottomConfirmWidgetState();
}

class _BottomConfirmWidgetState extends State<BottomConfirmWidget> {
  @override
  Widget build(BuildContext context) {
    Get.put(AlarmPillController());
    // Get.put(AlarmController());

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
        child: widget.isAlarm // 여기가 알람 등록 페이지
            ? GestureDetector(
                onTap: () async {
                  bool result = await confirm(
                    context,
                    title: const Text("컨펌"),
                    content: const Text("이 작업을 수행 하시겠습니까?"),
                    textOK: const Text("확인"),
                    textCancel: const Text("취소"),
                  );
                  if (result) {
                    bool? result;
                    if (widget.isAlarmUpdate == null) {
                      result = await controller.dioRequest("create", 0);
                    } else {
                      result = await controller.dioRequest(
                          "update", widget.reminderSeq!);
                    }
                    AlarmController alarmController =
                        Get.put(AlarmController());
                    alarmController.getAlarmList();
                    print(result);
                    if (result != null && result) {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return const AlertDialog(
                            title: Text('성공적으로 등록되었습니다!'),
                            content: Text('3초 뒤에 메인화면으로 이동합니다~'),
                          );
                        },
                      );

// 3초 후에 다이얼로그를 닫음
                      Timer(const Duration(seconds: 3), () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const BottomNavigation(where: 1)));
                      });
                    }
                  }
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.alarm_outlined,
                      size: 50,
                    ),
                    Text('알람 설정')
                  ],
                ),
              )
            : widget.isAlarmMyPill // 여기가 복약 목록 선택
                ? GestureDetector(
                    onTap: () {
                      controller.submitTemp();
                      Navigator.pop(context);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.check_circle_outlined,
                          size: 50,
                          color: Theme.of(context).colorScheme.background,
                        ),
                        const Text('확인')
                      ],
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                        GestureDetector(
                          onTap: () async {
                            if (widget.confirm != null) {
                              var temp = await widget.confirm!();
                              if (temp != null && temp) {
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    return const AlertDialog(
                                      title: Text('성공적으로 등록되었습니다!'),
                                      content: Text('3초 뒤에 메인화면으로 이동합니다~'),
                                    );
                                  },
                                );

// 3초 후에 다이얼로그를 닫음
                                Timer(const Duration(seconds: 3), () {
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
                              const Text('등록')
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
                              const Text('취소')
                            ],
                          ),
                        ),
                      ]),
      );
    });
  }
}
