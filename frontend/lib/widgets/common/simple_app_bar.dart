import 'package:flutter/material.dart';
import 'package:frontend/screens/profile/create_profile_page.dart';
import 'package:frontend/screens/profile/select_profile_image_page.dart';
import 'package:frontend/screens/settings/setting_bottom_sheet.dart';
import 'package:frontend/services/api_alarm_register.dart';
import 'package:get/get.dart';
import 'package:frontend/controller/alarm_controller.dart';

class SimpleAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final int? reminderSeq;

  const SimpleAppBar({Key? key, required this.title, this.reminderSeq})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    AlarmController alarmController = Get.put(AlarmController());
    Future<void> updateAlarmList() async {
      await ApiAlarmRegister.alarmDelete(reminderSeq);
      alarmController.getAlarmList();
    }

    List cancel = ["약 등록", "알람 수정", "알람 설정"];
    return AppBar(
      backgroundColor: Colors.white,
      // 약 등록일 때는 뒤로가기 시에 한번 물어봐주기
      leading: cancel.contains(title)
          ? IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('변경사항을 취소하시겠습니까?'),
                          ],
                        ),
                        content: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('아니오',
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 15))),
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  '예',
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 15),
                                ))
                          ],
                        ));
                  },
                );
              },
              icon: const Icon(Icons.arrow_back_ios_outlined,
                  color: Colors.black),
            )
          : IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_ios_outlined,
                  color: Colors.black),
            ),
      title: Text(title, style: const TextStyle(color: Colors.black)),
      centerTitle: true,
      actions: [
        if (title == '알람 수정')
          TextButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      print('here!!!!!!!!!!');
                      return AlertDialog(
                          title: Text('정말 알람을 삭제하시겠습니까?'),
                          content: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('취소',
                                      style: TextStyle(
                                          fontSize: 15, color: Colors.grey))),
                              TextButton(
                                  onPressed: () {
                                    updateAlarmList();
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    '삭제',
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.red),
                                  ))
                            ],
                          ));
                    });
              },
              child: const Text(
                '삭제',
                style: TextStyle(
                  color: Colors.red,
                ),
              ))
        else if (title == '사용자 전환')
          IconButton(
            onPressed: () {
              // 프로필 추가. 회원 연동 추가 모달 띄우기
              _showModalBottomSheet(context);
            },
            icon: const Icon(Icons.add, color: Colors.black),
          )
        else if (title == '프로필 선택')
          IconButton(
            onPressed: () {
              // 프로필 추가. 회원 연동 추가 모달 띄우기
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CreateProfilePage(),
                ),
              );
            },
            icon: const Icon(Icons.add, color: Colors.black),
          )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  void _showModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black.withOpacity(0.5),
      builder: (BuildContext context) {
        return Container(
            color: Colors.white, child: const SettingBottomSheet());
      },
    );
  }
}
