// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:frontend/widgets/mypills/my_pill.dart';

class DrugHistoryPage extends StatefulWidget {
  const DrugHistoryPage({Key? key}) : super(key: key);

  @override
  State<DrugHistoryPage> createState() => _DrugHistoryPageState();
}

class _DrugHistoryPageState extends State<DrugHistoryPage> {
  bool isClicked = true;

  void onClickLeft() {
    setState(() {
      isClicked = true;
    });
  }

  void onClickRight() {
    setState(() {
      isClicked = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 맨위 탭,  할것: 이너쉐도우 넣어야함 - 초고난이도
        Flexible(
          flex: 2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                flex: 1,
                child: GestureDetector(
                  onTap: onClickLeft,
                  child: Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                        ),
                        color: isClicked
                            ? Color.fromARGB(255, 187, 228, 203)
                            : Color.fromARGB(255, 225, 225, 225)),
                    child: Text(
                      "복용중",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: isClicked ? Colors.black : Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: GestureDetector(
                  onTap: onClickRight,
                  child: Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                        color: !isClicked
                            ? Color.fromARGB(255, 187, 228, 203)
                            : Color.fromARGB(255, 225, 225, 225)),
                    child: Text(
                      "복용끝",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: !isClicked ? Colors.black : Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        // 바디 부분
        Flexible(
            flex: 25,
            child: isClicked
                ? Column(
                    children: [
                      // 총 몇 건인지
                      Flexible(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 0, horizontal: 20),
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: Text("총 4건"),
                          ),
                        ),
                      ),
                      // 컴포넌트 들 -> 탭의 선택에 따라 달라져야 함
                      Flexible(
                        flex: 24,
                        child: ListView(
                          children: [
                            MyPill(),
                            MyPill(),
                            MyPill(),
                            MyPill(),
                            MyPill(),
                            MyPill(),
                            MyPill(),
                            MyPill(),
                          ],
                        ),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      Container(
                        child: Column(
                          children: [
                            Text("복용 끝"),
                            MyPill(),
                          ],
                        ),
                      ),
                      Container(
                        child: Column(
                          children: [
                            Text("복용 끝"),
                            MyPill(),
                          ],
                        ),
                      ),
                      Container(
                        child: Column(
                          children: [
                            Text("복용 끝"),
                            MyPill(),
                          ],
                        ),
                      ),
                    ],
                  )),
      ],
    );
  }

  // 나의 약이 없을 때
  Row emptyPill() {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.medication,
                  size: 58,
                ),
                Text(
                  "복용한 내역이 없습니다.",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.blue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
