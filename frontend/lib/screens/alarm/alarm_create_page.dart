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
    required this.isCreate, // isCreate = fasle 일 때는 수정 페이지
    this.alarmDetail,
  }) : super(key: key);
  final bool isCreate;
  final Map? alarmDetail;

  @override
  State<AlarmCreatePage> createState() => _AlarmCreatePageState();
}

class _AlarmCreatePageState extends State<AlarmCreatePage> {
  AlarmPillController controller = Get.put(AlarmPillController());
  TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.alarmDetail != null) {
      _textEditingController.text = widget.alarmDetail!["title"] ?? "";
      controller.displayListToupdate(widget.alarmDetail!["medicineList"]);
    }
  }

  @override
  void dispose() {
    super.dispose();

    controller.clear();
  }

  DateTime _time = DateTime.now();

  // 약 리스트 구성하는 부분

  @override
  Widget build(BuildContext context) {
    Get.put(AlarmPillController());
    return Scaffold(
        appBar: SimpleAppBar(
            title: widget.isCreate ? '알람 설정' : '알람 수정',
            reminderSeq: !widget.isCreate
                ? widget.alarmDetail!["reminderSeq"]
                : null), //TODO: 알람 수정인 경우에는 simpeAppBar에 알람삭제 버튼!
        body: GetBuilder<AlarmPillController>(builder: (controller) {
          if (widget.isCreate)
            return Stack(children: [
              ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Text('알람 제목',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 5),
                    child: TextField(
                      decoration: InputDecoration(hintText: '알람 제목을 입력해주세요'),
                      onChanged: (text) {
                        controller.setTitle(text);
                      },
                    ),
                  ),
                  CustomTimePicker(
                      setTime: controller.setTime,
                      time: _time,
                      isCreate: widget.isCreate),
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
                      ? SingleChildScrollView(
                          child: Column(children: [
                            ...controller.displayList
                                .map((pill) =>
                                    MyPillForAlarmRegister(data: pill))
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
          else // 여기부터 수정 페이지
            // var alarmDetail = widget.alarmDetail;

            return Stack(children: [
              ListView(
                children: [
                  TextField(
                    controller: _textEditingController,
                    decoration: InputDecoration(hintText: '알람 제목을 입력해주세요'),
                    onChanged: (text) {
                      controller.setTitle(text);
                    },
                  ),
                  CustomTimePicker(
                    setTime: controller.setTime,
                    time: _time,
                    isCreate: widget.isCreate,
                    originalTime: widget.alarmDetail!["time"],
                  ),
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
                      ? SingleChildScrollView(
                          child: Column(children: [
                            ...controller.displayList
                                .map((pill) =>
                                    MyPillForAlarmRegister(data: pill))
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
                        isAlarm: true,
                        isAlarmMyPill: false,
                        isAlarmUpdate: true,
                        reminderSeq: widget.alarmDetail!["reminderSeq"],
                      ))
                  : SizedBox()
            ]);
        }));
  }
}
//{reminderSeq: 1, title: null, time: 09:20:AM, totalCount: 2, typeCount: 2, medicineList: [{medicineSeq: 201600490, img: https://nedrug.mfds.go.kr/pbp/cmn/itemImageDownload/1McEBdO4Bq0, name: 플로라딘연질캡슐(로라타딘), tags: [{name: 알러지, color: 0}], count: 1}, {medicineSeq: 197900277, img: https://nedrug.mfds.go.kr/pbp/cmn/itemImageDownload/1N5PLuAiUvi, name: 게보린정(수출명:돌로린정), tags: [{name: 진통제, color: 1}], count: 1}]}