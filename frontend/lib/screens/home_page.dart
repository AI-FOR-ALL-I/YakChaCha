import 'package:flutter/material.dart';
import 'package:frontend/widgets/main/eat_check_button.dart';
import 'package:frontend/widgets/main/time_header.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(0.0),
        child: ListView(
          children: const [
            TimeHeader(
              nickname: 'user',
              timeline: 0,
            ),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    "약 먹어야하는 시간",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 16.0),
                  ),
                ),
                Icon(Icons.schedule, size: 20.0),
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
                  child: Text(
                    "17:00",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 16.0),
                  ),
                ),
              ],
            ),
            // 시간 다가오는지 여부에 따라 활성화?
            Padding(
              padding: EdgeInsets.all(10.0),
              child: EatCheckButton(),
            )
          ],
        ),
      ),
    );
  }
}
