import 'package:flutter/material.dart';
import 'package:frontend/widgets/alarm/alarm_widget.dart';
import 'package:frontend/screens/alarm/alarm_create_page.dart';
import 'package:frontend/controller/alarm_controller.dart';
import 'package:get/get.dart';

class AlarmPage extends StatefulWidget {
  const AlarmPage({Key? key}) : super(key: key);

  @override
  State<AlarmPage> createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage> {
  getAlarmList() async {
    var controller = Get.put(AlarmController());
    // List alarms = await controller.getAlarmList(); // 원래거
    List alarms = await controller.getAlarmList() ?? [];
  }

  @override // 알람 목록 받아오기
  void initState() {
    super.initState();
    getAlarmList();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        appBar: AppBar(
          title: Text('알람',
              style: TextStyle(
                  color: Colors.black,
                  fontSize:
                      MediaQuery.of(context).size.height >= 720 ? 30 : 16)),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: GetBuilder<AlarmController>(builder: (controller) {
          return Container(
            child: Stack(
              children: [
                ListView.builder(
                    itemCount: controller.alarmList.length,
                    itemBuilder: (context, i) {
                      return CustomAlarmWidget(data: controller.alarmList[i]);
                    }),
                Positioned(
                  bottom: 40,
                  right: 40,
                  child: FloatingActionButton(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AlarmCreatePage(
                                      isCreate: true,
                                    )));
                      },
                      child: Text('+', style: TextStyle(color: Colors.white))),
                )
              ],
            ),
          );
        }),
      ),
    );
  }
}
