import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:frontend/widgets/common/simple_app_bar.dart';
import 'package:frontend/widgets/common/tag_picker.dart';
import 'package:frontend/widgets/common/bottom_confirm_widget.dart';
import 'package:frontend/widgets/mypills/my_pill_for_alarm_register.dart';
import 'package:frontend/widgets/alarm/custom_time_picker.dart';
import 'package:frontend/widgets/alarm/tag_picker_for_alarm_page.dart';
import 'package:frontend/screens/alarm/alarm_my_pill_page.dart';
import 'package:frontend/controller/alarm_pill_controller.dart';

class AlarmCreatePage extends StatefulWidget {
  const AlarmCreatePage({
    Key? key,
    required this.isCreate,
  }) : super(key: key);
  final bool isCreate;

  @override
  State<AlarmCreatePage> createState() => _AlarmCreatePageState();
}

class _AlarmCreatePageState extends State<AlarmCreatePage> {
  AlarmPillController controller = Get.put(AlarmPillController());

  @override
  void dispose() {
    super.dispose();
    controller.clear();
    print('here!!!!');
  }

  DateTime _time = DateTime.now();

  // 약 리스트 구성하는 부분

  @override
  Widget build(BuildContext context) {
    Get.put(AlarmPillController());
    return Scaffold(
        appBar: SimpleAppBar(
            title: widget.isCreate
                ? '알람 설정'
                : '알람 수정'), //TODO: 알람 수정인 경우에는 simpeAppBar에 알람삭제 버튼!
        body: GetBuilder<AlarmPillController>(builder: (controller) {
          return Stack(children: [
            ListView(
              children: [
                TextField(
                  decoration: InputDecoration(hintText: '알람 제목을 입력해주세요'),
                  onChanged: (text) {
                    controller.setTitle(text);
                  },
                ),
                CustomTimePicker(setTime: controller.setTime, time: _time),
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
                TagPickerForAlarmPage(),
                AspectRatio(
                    aspectRatio: 296 / 101,
                    child: GestureDetector(
                      onTap: () {
                        controller.setTempList();
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
                controller.displayList.isNotEmpty
                    ? Expanded(
                        child: Column(children: [
                          ...controller.displayList
                              .map((pill) => MyPillForAlarmRegister(data: pill))
                              .toList(),
                          SizedBox(height: 100)
                        ]),
                      )
                    : SizedBox()
              ],
            ),
            controller.displayList.isNotEmpty
                ? Positioned(
                    bottom: 0,
                    child: BottomConfirmWidget(
                        isAlarm: true, isAlarmMyPill: false))
                : SizedBox()
          ]);
        }));
  }
}
