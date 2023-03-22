import 'package:flutter/material.dart';
import 'package:frontend/screens/alarm/alarm_detail_page.dart';

class CustomAlarmWidget extends StatelessWidget {
  const CustomAlarmWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => AlarmDetailPage()));
      },
      child: AspectRatio(
        aspectRatio: 319 / 144,
        child: Container(
          margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(15)),
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
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.blue)),
                          child: Text('김준형 복약'),
                        ),
                        Container(
                          child: Text(
                            '09:30 AM',
                            style: TextStyle(fontSize: 40),
                          ),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.yellow)),
                        ),
                        Row(
                          children: [
                            Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.pink,
                                    ),
                                    borderRadius: BorderRadius.circular(15)),
                                child: Text('태그명 1')),
                            Text('태그명 2')
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.green)),
                    child: Icon(Icons.radio_button_unchecked_outlined),
                    // child: Icon(Icons.check_circle_outlined),
                  ) // 여기가 체크 아이콘
                ]),
          ),
        ),
      ),
    );
  }
}
