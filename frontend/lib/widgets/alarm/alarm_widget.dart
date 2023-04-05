import 'package:flutter/material.dart';
import 'package:frontend/screens/alarm/alarm_detail_page.dart';
import 'package:frontend/controller/alarm_controller.dart';
import 'package:get/get.dart';

class CustomAlarmWidget extends StatefulWidget {
  const CustomAlarmWidget({Key? key, required this.data}) : super(key: key);
  final Map data;

  @override
  State<CustomAlarmWidget> createState() => _CustomAlarmWidgetState();
}

class _CustomAlarmWidgetState extends State<CustomAlarmWidget> {
  Future<void> _goToDetail() async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                AlarmDetailPage(seq: widget.data["reminderSeq"])));
  }

  // {"reminderSeq":7,"title":"new Alarm","time":"01:00:PM","taken":false,"status":4}
  @override
  Widget build(BuildContext context) {
    Color statusColor = Colors.white;
    Color textColor = Color.fromARGB(255, 78, 78, 78);
    if (widget.data["status"] == 1) {
      statusColor = Color(0xFFFF9292);
      textColor = Color.fromARGB(255, 243, 243, 243);
    } else if (widget.data["status"] == 2) {
      statusColor = Color(0xFFBBE4CB);
    }
    Color statusBorderColor = Colors.transparent;

    // if (status == 3) {
    //   statusBorderColor = Theme.of(context).colorScheme.background;
    // }

    return GestureDetector(
      onTap: () {
        _goToDetail();
      },
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Material(
          elevation: 5,
          borderRadius: BorderRadius.circular(20),
          color: statusColor,
          child: AspectRatio(
            aspectRatio: 320 / 120,
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
                            margin: EdgeInsets.only(left: 20),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: widget.data["title"] != null
                                  ? Text(widget.data["title"])
                                  : Text(
                                      "약 먹을 시간이에요!",
                                      style: TextStyle(
                                          fontSize: 16, color: textColor),
                                    ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 20),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                widget.data["time"].split(':')[0] +
                                    ":" +
                                    widget.data["time"].split(':')[1] +
                                    " " +
                                    widget.data["time"].split(':')[2],
                                style: TextStyle(
                                    fontSize: 42,
                                    fontWeight: FontWeight.w500,
                                    color: textColor),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 15.0),
                      child: Container(
                          child: (widget.data["status"] == 1)
                              ? GestureDetector(
                                  child: Icon(
                                    Icons.error_outline_outlined,
                                    size: 35,
                                    color: textColor,
                                  ),
                                  onTap: () {
                                    var controller = Get.put(AlarmController());
                                    controller
                                        .takePill(widget.data["reminderSeq"]);
                                  })
                              : (widget.data["status"] == 2)
                                  ? Icon(
                                      Icons.check_circle_outlined,
                                      size: 35,
                                      color: textColor,
                                    )
                                  : GestureDetector(
                                      child: Icon(
                                        Icons.radio_button_unchecked_outlined,
                                        size: 35,
                                        color: textColor,
                                      ),
                                      onTap: () {
                                        var controller =
                                            Get.put(AlarmController());
                                        controller.takePill(
                                            widget.data["reminderSeq"]);
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
