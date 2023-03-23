import 'package:flutter/material.dart';
import 'package:frontend/widgets/common/simple_app_bar.dart';
import 'package:frontend/widgets/common/tag_picker.dart';
import 'package:frontend/widgets/alarm/custom_time_picker.dart';

class AlarmCreatePage extends StatelessWidget {
  const AlarmCreatePage({Key? key, required this.isCreate}) : super(key: key);
  final bool isCreate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: SimpleAppBar(
            title: isCreate
                ? '알람 설정'
                : '알람 수정'), //TODO: 알람 수정인 경우에는 simpeAppBar에 알람삭제 버튼!
        body: Column(
          children: [
            // CustomTimePicker(),
            Text('복약 목록 설정'),
            TagPicker(),
            Container(), // 약 추가 하는 버튼
            // ListView() // 약 목록
          ],
        ));
  }
}
