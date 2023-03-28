// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:frontend/models/pill_detail_model.dart';
import 'package:frontend/screens/pill_details/pill_detail_line_state.dart';
import 'package:frontend/services/pill_detail_api.dart';
import 'package:frontend/widgets/common/simple_app_bar.dart';

class PillDetailsForApi extends StatelessWidget {
  final String num;
  const PillDetailsForApi({super.key, required this.num});

  @override
  Widget build(BuildContext context) {
    final Future<PillDetailModel> pillDetail = PillDetailApi.getPillDetail(num);
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: SimpleAppBar(title: "약 상세"),
      body: FutureBuilder(
        future: pillDetail,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return pillDetailList(snapshot);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  ListView pillDetailList(AsyncSnapshot<PillDetailModel> snapshot) {
    var pillDetail = snapshot.data!;
    return ListView(
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
                  Image.network(pillDetail.img, fit: BoxFit.fill)),
        ),
        Column(
          children: [
            Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(vertical: 2, horizontal: 60),
                  child: Text(
                    pillDetail.itemName,
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
                      pillDetail.entpName,
                      textAlign: TextAlign.center,
                    )),
              ],
            ),
          ],
        ),
        Column(
          children: [
            PillDetailLine(lineTitle: "성분", content: pillDetail.mainItemIngr),
            PillDetailLine(lineTitle: "효능", content: pillDetail.eeDocData),
            PillDetailLine(lineTitle: "복용 방법", content: pillDetail.udDocData),
            PillDetailLine(lineTitle: "보관 방법", content: pillDetail.storageMethod),
            PillDetailLine(lineTitle: "복용 시 주의사항", content: pillDetail.nbDocData),
            PillDetailLine(lineTitle: "함께 먹지 말아야 하는 성분", content: pillDetail.typeCode),
          ],
        )
      ],
    );
  }
}
