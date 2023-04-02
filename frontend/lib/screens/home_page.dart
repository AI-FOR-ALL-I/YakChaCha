import 'package:flutter/material.dart';
import 'package:frontend/widgets/main/eat_check_button.dart';
import 'package:frontend/widgets/main/health_tip_item.dart';
import 'package:frontend/widgets/main/my_drug_item.dart';
import 'package:frontend/widgets/main/time_header.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:frontend/controller/firebase_controller.dart';
import 'package:frontend/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:frontend/main.dart';

class HomePage extends StatefulWidget {
  // final List<Map<String, String>> myList = [
  //   {'title': 'title1'},
  //   {'title': 'title2'},
  // ];
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Scaffold(
        body: Column(
          children: [
            const TimeHeader(
              nickname: 'user',
              timeline: 0,
            ),
            Expanded(
                child: MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: ListView(
                children: [
                  Row(
                    children: const [
                      Padding(
                        padding: EdgeInsets.all(15.0),
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
                        padding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 5.0),
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
                    padding: EdgeInsetsDirectional.symmetric(
                        horizontal: 15.0, vertical: 15.0),
                    child: Text(
                      "내 약 목록",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 16.0),
                    ),
                  ),
                  SizedBox(
                    height: 150,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 5,
                        itemBuilder: (BuildContext context, int index) {
                          return const MyDrugItem(
                            imagePath: 'assets/images/night.png',
                            title: '약 이름 params',
                          );
                        }),
                  ),
                  const Padding(
                    padding: EdgeInsetsDirectional.symmetric(
                        horizontal: 15.0, vertical: 15.0),
                    child: Text(
                      "상식 어쩌구",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 16.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 8.0),
                    child: SizedBox(
                      width: 300,
                      height: 290,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 5,
                          itemBuilder: (BuildContext context, int index) {
                            return const HealthTipItem();
                          }),
                    ),
                  )
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }
}
