import 'package:flutter/material.dart';
import 'package:frontend/widgets/alarm/alarm_widget.dart';
import 'package:frontend/screens/alarm/alarm_create_page.dart';
import 'package:frontend/controller/alarm_controller.dart';
import 'package:frontend/widgets/common/is_empty_pills.dart';
import 'package:get/get.dart';

class AlarmPage extends StatefulWidget {
  const AlarmPage({Key? key}) : super(key: key);

  @override
  State<AlarmPage> createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage> {
  List alarms = [];

  getAlarmList() async {
    var controller = Get.put(AlarmController());
    alarms = await controller.getAlarmList() ?? [];
  }

  Future<void> _goToUpdate() async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const AlarmCreatePage(
                  isCreate: true,
                )));
    await getAlarmList();
  }

  @override // 알람 목록 받아오기
  void initState() {
    super.initState();
    getAlarmList();
  }

  @override
  Widget build(BuildContext context) {
    print(alarms);
    return Center(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: false,
          titleSpacing: NavigationToolbar.kMiddleSpacing,
          title: Text('알람',
              style: TextStyle(
                  color: Colors.black,
                  fontSize:
                      MediaQuery.of(context).size.height >= 720 ? 30 : 16)),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: GetBuilder<AlarmController>(builder: (controller) {
          return Stack(
            children: [
              alarms.isEmpty
                  ? const IsEmptyPills(what: "알람")
                  : ListView.builder(
                      padding: EdgeInsets.only(bottom: 30),
                      itemCount: controller.alarmList.length,
                      itemBuilder: (context, i) {
                        return CustomAlarmWidget(
                          data: controller.alarmList[i],
                        );
                      }),
              Positioned(
                bottom: 25,
                right: 20,
                child: FloatingActionButton(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    onPressed: () {
                      _goToUpdate();
                    },
                    child: const Text('+',
                        style: TextStyle(color: Colors.white, fontSize: 36))),
              )
            ],
          );
        }),
      ),
    );
  }
}
