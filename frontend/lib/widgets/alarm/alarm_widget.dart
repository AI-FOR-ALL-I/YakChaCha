import 'package:flutter/material.dart';
import 'package:frontend/screens/alarm/alarm_detail_page.dart';
import 'package:intl/intl.dart';

class CustomAlarmWidget extends StatelessWidget {
  const CustomAlarmWidget({Key? key, required this.status}) : super(key: key);
  final int status;

  @override
  Widget build(BuildContext context) {
    Color statusColor = Colors.white;

    if (status == 1) {
      statusColor = Theme.of(context).colorScheme.error;
    } else if (status == 2) {
      statusColor = Theme.of(context).colorScheme.primary;
    }
    Color statusBorderColor = Colors.transparent;

    // if (status == 3) {
    //   statusBorderColor = Theme.of(context).colorScheme.background;
    // }

    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => AlarmDetailPage()));
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
                              child: Text('알람 제목 자리~~~'),
                            ),
                          ),
                          Container(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                '09:30 AM',
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
                        child: Icon(Icons.radio_button_unchecked_outlined),
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
