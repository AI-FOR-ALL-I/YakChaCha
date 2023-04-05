// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:frontend/controller/my_pill_controller.dart';
import 'package:frontend/screens/myPills/my_pill_delete.dart';
import 'package:frontend/services/my_pill_api.dart';
import 'package:frontend/services/taken_pill_api.dart';
import 'package:frontend/widgets/common/is_empty_pills.dart';
import 'package:frontend/widgets/mypills/renew_my_pill.dart';
import 'package:get/get.dart';

class DrugHistoryPage extends StatefulWidget {
  const DrugHistoryPage({Key? key}) : super(key: key);

  @override
  State<DrugHistoryPage> createState() => _DrugHistoryPageState();
}

class _DrugHistoryPageState extends State<DrugHistoryPage> {
  bool isClicked = true;
  final myPillController = Get.put(MyPillController());

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

  final Future<List> myPills = MyPillApi.getMyPill();
  final Future<List> takenPills = TakenPillApi.getTakenPill();

  @override
  Widget build(BuildContext context) {
    int isOn = myPillController.isOn;
    return Column(
      children: [
        // 맨위 탭,  할것: 이너쉐도우 넣어야함 - 초고난이도
        Flexible(
          flex: 2,
          child: Column(
            children: [
              Expanded(
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
              isOn > 0 ? SizedBox() : SizedBox()
            ],
          ),
        ),
        // 바디 부분
        Flexible(
            flex: 25,
            child: isClicked
                ? FutureBuilder(
                    future: myPills,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return myPillList(snapshot);
                      } else {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  )
                : FutureBuilder(
                    future: takenPills,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return takenPillList(snapshot);
                      } else {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    })),
      ],
    );
  }

  Column takenPillList(AsyncSnapshot<List> snapshot) {
    if (!snapshot.hasData || snapshot.data!.isEmpty) {
      return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [IsEmptyPills(what: "알약")]);
    }

    List data = snapshot.data!;
    data.sort((a, b) {
      int aPeriodEnd =
          int.parse(a.period[1].replaceAll('-', '').substring(0, 6));
      int bPeriodEnd =
          int.parse(b.period[1].replaceAll('-', '').substring(0, 6));
      return bPeriodEnd - aPeriodEnd;
    });
    List<Map<String, dynamic>> sortedData = [];

    for (var item in data) {
      int periodEnd =
          int.parse(item.period[1].replaceAll('-', '').substring(0, 6));
      String periodEndStr = periodEnd.toString().padLeft(6, '0');
      int year = int.parse(periodEndStr.substring(0, 2)) + 2000;
      int month = int.parse(periodEndStr.substring(2, 4));
      int day = int.parse(periodEndStr.substring(4, 6));
      DateTime periodEndDate = DateTime(year, month, day);
      int periodEndDateInt = int.parse(
          "${periodEndDate.year.toString().substring(2)}${periodEndDate.month.toString().padLeft(2, '0')}${periodEndDate.day.toString().padLeft(2, '0')}");

      sortedData.add({"key": periodEndDateInt, "data": item});
    }

    sortedData.sort((a, b) => a["key"].compareTo(b["key"]));

    List sortedList = sortedData.map((item) => item["data"]).toList();
    List check = [];
    return Column(
      children: [
        Flexible(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.only(left: 25, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "총 ${snapshot.data!.length.toString()}건",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyPillDelete()));
                    },
                    icon: Icon(Icons.settings))
              ],
            ),
          ),
        ),
        Flexible(
          flex: 24,
          child: ListView.separated(
            itemCount: sortedList.length,
            separatorBuilder: (context, index) => SizedBox(
              height: 10,
            ),
            itemBuilder: (context, index) {
              var pill = sortedList[index];
              var peri = pill.period[1].substring(0, 7);
              var flag = false;
              if (!check.contains(peri)) {
                check.add(peri);
                flag = true;
              }
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  flag
                      ? Padding(
                          padding: const EdgeInsets.only(left: 30),
                          child: Text(
                            "${peri.substring(0, 4)}년 ${peri.substring(5, 7)}월 복용",
                            style: TextStyle(fontSize: 18),
                          ),
                        )
                      : SizedBox(),
                  RenewMyPill(
                    itemSeq: pill.itemSeq,
                    itemName: pill.itemName,
                    img: pill.img,
                    tag_list: pill.tagList,
                    isTaken: true,
                    dday: pill.dday,
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Column myPillList(AsyncSnapshot<List> snapshot) {
    var isZero = false;
    if (snapshot.data!.isEmpty) {
      isZero = true;
    } else {
      snapshot.data!.sort((a, b) => a.dday.compareTo(b.dday));
    }
    return isZero
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [IsEmptyPills(what: "알약")],
          )
        : Column(
            children: [
              Flexible(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.only(left: 25, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "총 ${snapshot.data!.length.toString()}건",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MyPillDelete()));
                          },
                          icon: Icon(Icons.settings))
                    ],
                  ),
                ),
              ),
              Flexible(
                flex: 24,
                child: ListView.separated(
                  itemCount: snapshot.data!.length,
                  separatorBuilder: (context, index) => SizedBox(),
                  itemBuilder: (context, index) {
                    var pill = snapshot.data![index];
                    return RenewMyPill(
                        itemSeq: pill.itemSeq,
                        itemName: pill.itemName,
                        img: pill.img,
                        tag_list: pill.tagList,
                        isTaken: false,
                        dday: pill.dday);
                  },
                ),
              ),
            ],
          );
  }
}
