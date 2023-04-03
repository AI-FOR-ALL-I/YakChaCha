import 'package:flutter/material.dart';
import 'package:frontend/screens/alarm/alarm_detail_page.dart';
import 'package:frontend/controller/alarm_controller.dart';
import 'package:get/get.dart';

class CustomAlarmWidget extends StatelessWidget {
  const CustomAlarmWidget({Key? key, required this.data}) : super(key: key);
  final Map data;
  // {"reminderSeq":7,"title":"new Alarm","time":"01:00:PM","taken":false,"status":4}
  @override
  Widget build(BuildContext context) {
    Color statusColor = Colors.white;

    if (data["status"] == 1) {
      statusColor = Theme.of(context).colorScheme.error;
    } else if (data["status"] == 2) {
      statusColor = Theme.of(context).colorScheme.primary;
    }
    Color statusBorderColor = Colors.transparent;

    // if (status == 3) {
    //   statusBorderColor = Theme.of(context).colorScheme.background;
    // }

    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    AlarmDetailPage(seq: data["reminderSeq"])));
      },
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Material(
          elevation: 5,
          borderRadius: BorderRadius.circular(20),
          color: statusColor,
          child: AspectRatio(
            aspectRatio: 319 / 144,
            child: Center(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: data["title"] != null
                                  ? Text(data["title"])
                                  : Text("약 먹을 시간!"),
                            ),
                          ),
                          Container(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                data["time"].split(':')[0] +
                                    ":" +
                                    data["time"].split(':')[1] +
                                    " " +
                                    data["time"].split(':')[2],
                                style: TextStyle(fontSize: 40),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 15.0),
                      child: Container(
                          child: (data["status"] == 1)
                              ? Icon(Icons.error_outline_outlined)
                              : (data["status"] == 2)
                                  ? Icon(Icons.check_circle_outlined)
                                  : GestureDetector(
                                      child: Icon(Icons
                                          .radio_button_unchecked_outlined),
                                      onTap: () {
                                        var controller =
                                            Get.put(AlarmController());
                                        controller
                                            .takePill(data["reminderSeq"]);
                                      })

                          // child: Icon(Icons.check_circle_outlined),
                          ),
                    ) // 여기가 체크 아이콘
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
