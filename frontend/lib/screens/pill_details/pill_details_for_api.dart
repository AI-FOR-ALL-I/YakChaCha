// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:frontend/models/pill_detail_model.dart';
import 'package:frontend/screens/pill_details/pill_detail_line_state.dart';
import 'package:frontend/services/pill_detail_api.dart';
import 'package:frontend/widgets/common/simple_app_bar.dart';
import 'package:frontend/controller/pill_register_controller.dart';
import 'package:frontend/widgets/common/tag_widget.dart';
import 'package:get/get.dart';

class PillDetailsForApi extends StatelessWidget {
  final String num;
  final bool turnOnPlus;
  const PillDetailsForApi(
      {super.key, required this.num, required this.turnOnPlus});

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
    var img = '';
    var imgFlag = false;
    if (pillDetail.img == "") {
      img = 'assets/images/defaultPill1.png';
      imgFlag = true;
    } else {
      img = pillDetail.img;
    }
    // print("@@@@@@@@@@@@@@  ${pillDetail.tagList} @@@@@@@@@@@@@@@@");
    return ListView(
      children: [
        // 약 등록, turnOnPlus:true 켜짐
        turnOnPlus
            ? Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 2, horizontal: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "약 등록",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    GetBuilder<PillRegisterController>(
                        tag: "registerController",
                        builder: (controller) {
                          return IconButton(
                            onPressed: () {
                              // 필요한 자료
                              var tempData = {
                                'itemSeq': pillDetail.itemSeq,
                                'img': img,
                                'itemName': pillDetail.itemName,
                                'warnPregnant':
                                    false, // TODO: 위험여부 받아서 여기다 넣어줘야 함...
                                'warnAge': false,
                                'warnOld': false,
                                'collide': false
                              };
                              controller.add(tempData);
                              print(controller.displayList[
                                  controller.displayList.length - 1]);
                              Get.back(); // 이거 되나
                            },
                            icon: Icon(
                              Icons.add_box_outlined,
                              color: Color(0xFF4AC990),
                              size: 30,
                            ),
                          );
                        })
                  ],
                ),
              )
            : SizedBox(),
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
              child: imgFlag
                  ? Image.asset(img, fit: BoxFit.fill)
                  : Image.network(img, fit: BoxFit.fill)),
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
        turnOnPlus
            ? SizedBox()
            : Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 1, vertical: 20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: pillDetail.tagList
                          .map((tagInfo) => TagWidget(
                              tagName: tagInfo[0],
                              colorIndex: int.parse(tagInfo[1])))
                          .toList(),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "복용기간:  ",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w700),
                        ),
                        Text(
                          "${pillDetail.startDate} ~ ${pillDetail.endDate}",
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    )
                  ],
                ),
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
