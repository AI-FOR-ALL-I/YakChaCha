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
        // 약 등록을 조건부로 걸어줘야함
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "약 등록",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.add_box_outlined,
                  color: Color(0xFF4AC990),
                  size: 30,
                ),
              )
            ],
          ),
        ),
        // 약 사진
        Container(
          margin: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
          width: double.infinity,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: AspectRatio(
              aspectRatio: 2 / 1,
              child: Image.network(pillDetail.img, fit: BoxFit.fill)),
        ),

        // 약 이름 + 제조 회사
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
        // 태그명 & 복용 기간 부분, 조건부로 안보이게 해야함 + 수정가능하도록
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("태그명1",
                  style: TextStyle(fontSize: 20),
                ),
                Text("태그명2",
                  style: TextStyle(fontSize: 20),
                ),
                IconButton(onPressed: (){}, icon: Icon(Icons.mode_edit_outlined))
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("복용기간",
                  style: TextStyle(fontSize: 20),
                ),
                Text("2023.03.01 ~ 2023.03.02",
                  style: TextStyle(fontSize: 20),
                ),
                IconButton(onPressed: (){}, icon: Icon(Icons.mode_edit_outlined))
              ],
            )
          ],
        ),
        // 상세 설명 부분
        Column(
          children: [
            PillDetailLine(lineTitle: "성분", content: pillDetail.mainItemIngr),
            PillDetailLine(lineTitle: "효능", content: pillDetail.eeDocData),
            PillDetailLine(lineTitle: "복용 방법", content: pillDetail.udDocData),
            PillDetailLine(
                lineTitle: "보관 방법", content: pillDetail.storageMethod),
            PillDetailLine(
                lineTitle: "복용 시 주의사항", content: pillDetail.nbDocData),
            PillDetailLine(
                lineTitle: "함께 먹지 말아야 하는 성분", content: pillDetail.typeCode),
          ],
        )
      ],
    );
  }
}
