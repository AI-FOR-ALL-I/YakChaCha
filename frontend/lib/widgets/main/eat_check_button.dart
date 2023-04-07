import 'package:flutter/material.dart';
import 'package:frontend/screens/alarm/alarm_detail_page.dart';
import 'package:frontend/controller/alarm_controller.dart';
import 'package:get/get.dart';

class EatCheckButton extends StatelessWidget {
  const EatCheckButton({super.key, required this.data});
  final Map data;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: const Color(0xFFFFF8EA)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                  child: Image.asset(
                    'assets/images/mainbuttonpills.png',
                    width: 50,
                    height: 50,
                    fit: BoxFit.fill,
                  ),
                  onTap: () {
                    var controller = Get.put(AlarmController());
                    controller.takePill(data["reminderSeq"]);
                  }),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      '약 먹을 시간이에요',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '먹었다면 알약을 눌러주세요',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
