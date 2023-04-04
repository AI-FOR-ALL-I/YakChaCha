import 'package:flutter/material.dart';
import 'package:frontend/screens/alarm_page.dart';
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

    return AppBar(
      backgroundColor: Colors.white,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(Icons.arrow_back_ios_outlined, color: Colors.black),
      ),
      title: Text(title, style: const TextStyle(color: Colors.black)),
      centerTitle: true,
      actions: [
        if (title == '알람 수정')
          TextButton(
              onPressed: () {
                // TODO: 만약에 알람을 삭제하고 알람 메인 페이지로 이동하면, 뒤로가기 눌렀을 때 어떻게 되는 거지..?
                updateAlarmList();
                Navigator.pop(context);
                Navigator.pop(context);
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
