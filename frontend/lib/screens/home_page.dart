import 'package:flutter/material.dart';
import 'package:frontend/widgets/main/eat_check_button.dart';
import 'package:frontend/widgets/main/time_header.dart';

class HomePage extends StatelessWidget {
  // final List<Map<String, String>> myList = [
  //   {'title': 'title1'},
  //   {'title': 'title2'},
  // ];
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(0.0),
        child: ListView(
          children: [
            const TimeHeader(
              nickname: 'user',
              timeline: 0,
            ),
            const Row(
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
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: EatCheckButton(),
            ),
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                "내 약 목록",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 16.0),
              ),
            ),
            SizedBox(
              height: 100,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 3,
                  itemBuilder: (BuildContext context, int index) {
                    return SizedBox(
                      width: 200.0,
                      height: 200.0,
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Color(0xFFFFF8EA),
                        ),
                        child: Column(
                          children: [
                            Image.asset('assets/images/night.png',
                                width: 100, height: 70, fit: BoxFit.fitWidth),
                            const Text('타이레놀'),
                          ],
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
