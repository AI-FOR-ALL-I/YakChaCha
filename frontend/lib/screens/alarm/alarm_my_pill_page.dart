import 'package:flutter/material.dart';
import 'package:frontend/widgets/common/simple_app_bar.dart';
import 'package:frontend/widgets/mypills/my_pill.dart';

class AlarmMyPillPage extends StatelessWidget {
  const AlarmMyPillPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(title: '복약 목록 선택'),
      body: Column(
        children: [
          Text('등록된 약 목록'),
          ListView.builder(
              itemCount: 10,
              itemBuilder: ((context, index) {
                return MyPill(
                  isAlarmRegister: false,
                );
              }))
        ],
      ),
    );
  }
}
