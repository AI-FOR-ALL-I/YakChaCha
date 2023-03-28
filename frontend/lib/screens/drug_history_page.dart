// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:frontend/models/my_pill_model.dart';
import 'package:frontend/services/my_pill_api.dart';
import 'package:frontend/services/taken_pill_api.dart';
import 'package:frontend/widgets/mypills/my_pill.dart';
import 'package:frontend/widgets/mypills/renew_my_pill.dart';

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

  final Future<List<MyPillModel>> myPills = MyPillApi.getMyPill();
  final Future<List<MyPillModel>> takenPills = TakenPillApi.getTakenPill();

  int howManyPills = 0;
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

  ListView takenPillList(AsyncSnapshot<List<MyPillModel>> snapshot) {
    return ListView.separated(
      itemCount: snapshot.data!.length,
      separatorBuilder: (context, index) => SizedBox(),
      itemBuilder: (context, index) {
        var pill = snapshot.data![index];
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text("복용 끝"),
            RenewMyPill(
              id: pill.id,
              name: pill.name,
              picture: pill.picture,
              title: pill.title,
              isTaken: true,
            ),
          ],
        );
      },
    );
  }

  Column myPillList(AsyncSnapshot<List<MyPillModel>> snapshot) {
    return Column(
      children: [
        Flexible(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
            child: Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "총 ${snapshot.data!.length.toString()}건",
                style: TextStyle(fontSize: 16),
              ),
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
                id: pill.id,
                name: pill.name,
                picture: pill.picture,
                title: pill.title,
                isTaken: false,
              );
            },
          ),
        ),
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
