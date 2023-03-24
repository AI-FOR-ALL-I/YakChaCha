import 'package:flutter/material.dart';
import 'package:frontend/widgets/common/simple_app_bar.dart';
import 'package:frontend/widgets/common/tag_picker.dart';
import 'package:frontend/widgets/mypills/my_pill.dart';
import 'package:frontend/widgets/alarm/custom_time_picker.dart';
import 'package:frontend/screens/alarm/alarm_my_pill_page.dart';

class AlarmCreatePage extends StatefulWidget {
  const AlarmCreatePage({Key? key, required this.isCreate}) : super(key: key);
  final bool isCreate;

  @override
  State<AlarmCreatePage> createState() => _AlarmCreatePageState();
}

class _AlarmCreatePageState extends State<AlarmCreatePage> {
  var selectedPillsList = [1, 2, 3, 4, 5];
  String _title = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: SimpleAppBar(
            title: widget.isCreate
                ? '알람 설정'
                : '알람 수정'), //TODO: 알람 수정인 경우에는 simpeAppBar에 알람삭제 버튼!
        body: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(hintText: '알람 제목을 입력해주세요'),
                onChanged: (text) {
                  setState(() {
                    _title = text;
                  });
                },
              ),
              CustomTimePicker(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('복약 목록 설정',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              TagPicker(), // 약 추가 하는 버튼
              AspectRatio(
                  aspectRatio: 296 / 101,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AlarmMyPillPage()));
                    },
                    child: Container(
                        margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color(0xFFBBE4CB)),
                        child: Icon(Icons.add, color: Colors.white)),
                  )),
              Column(
                children: selectedPillsList
                    .map((pill) => MyPill(
                          isAlarmRegister: true,
                        ))
                    .toList(),
              ) // 약 목록
            ],
          ),
        ));
  }
}
