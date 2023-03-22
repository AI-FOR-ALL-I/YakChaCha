// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:frontend/screens/pill_details/pill_detail_line_state.dart';

class PillDetails extends StatefulWidget {
  const PillDetails({super.key});

  @override
  State<PillDetails> createState() => _PillDetailsState();
}

class _PillDetailsState extends State<PillDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text("약 상세"), centerTitle: true),
      body: ListView(
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
            width: double.infinity,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: AspectRatio(
                aspectRatio: 2 / 1,
                child:
                    Image.asset('assets/images/pills.png', fit: BoxFit.fill)),
          ),
          Column(
            children: [
              Column(
                children: [
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.symmetric(vertical: 2, horizontal: 60),
                    child: Text(
                      "타이레놀정500밀리그람(아세트아미노펜)",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.symmetric(vertical: 2, horizontal: 60),
                      child: Text(
                        "(주) 한국얀센",
                        textAlign: TextAlign.center,
                      )),
                ],
              ),
            ],
          ),
          Column(
            children: [
              PillDetailLine(
                lineTitle: "성분",
                content: "아세트아미노펜"
              ),
              PillDetailLine(
                lineTitle: "효능",
                content: "감기로 인한 발열 및 동통(통증), 두통, 신경통, 근육통, 월경통, 염좌통(삔 통증), 치통, 관절통, 류마티양 동통(통증)",
              ),
            ],
          )
        ],
      ),
    );
  }
}
