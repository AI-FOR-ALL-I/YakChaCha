// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:frontend/bottom_navigation.dart';
import 'package:frontend/controller/my_pill_controller.dart';
import 'package:frontend/screens/pill_details/pill_details_for_api.dart';
import 'package:frontend/services/api_delete_my_pill.dart';
import 'package:frontend/widgets/common/tag_widget.dart';
import 'package:get/get.dart';

class DeleteMyPill extends StatefulWidget {
  final String itemName, img;
  final int itemSeq, myMedicineSeq;
  final List tag_list;

  const DeleteMyPill({
    super.key,
    required this.itemSeq,
    required this.itemName,
    required this.img,
    required this.tag_list,
    required this.myMedicineSeq,
  });

  @override
  State<DeleteMyPill> createState() => _DeleteMyPillState();
}

class _DeleteMyPillState extends State<DeleteMyPill> {
  MyPillController myPillController = Get.put(MyPillController());

  Future<void> deletePill() async {
    await ApiDeleteMyPill.getPillDetail(widget.myMedicineSeq);
    myPillController.getPillList();
    myPillController.getTakenPillList();
  }

  @override
  void dispose() {
    super.dispose();
    myPillController.clear();
  }

  @override
  Widget build(BuildContext context) {
    var imgFlag = false;
    if (widget.img == "") {
      imgFlag = true;
    }

    return Container(
      child: Stack(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PillDetailsForApi(
                        turnOnPlus: false,
                        isRegister: false,
                        num: widget.itemSeq.toString()),
                  ));
            },
            child: AspectRatio(
              aspectRatio: 3 / 1,
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                padding: const EdgeInsets.all(15),
                // height: 100,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.transparent, width: 2.0),
                  boxShadow: [
                    BoxShadow(
                        offset: Offset(1, 1),
                        blurRadius: 2,
                        color: Colors.black12)
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    AspectRatio(
                      aspectRatio: 1.7 / 1,
                      child: Container(
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: imgFlag
                              ? Image.asset(
                                  'assets/images/defaultPill1.png',
                                  fit: BoxFit.fill,
                                )
                              : Image.network(widget.img, fit: BoxFit.fill,
                                  errorBuilder: (BuildContext context,
                                      Object exception,
                                      StackTrace? stackTrace) {
                                  return Image.asset(
                                      'assets/images/defaultPill1.png');
                                })),
                    ), // 이미지
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Flexible(
                                    child: Text(widget.itemName,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: TextStyle(fontSize: 15)),
                                  )
                                ]),
                          ),
                          Container(
                            alignment: Alignment.bottomLeft,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: widget.tag_list
                                    .map((tagInfo) => TagWidget(
                                        tagName: tagInfo["name"],
                                        colorIndex: tagInfo["color"]))
                                    .toList(),
                              ),
                            ),
                          )
                        ],
                      ),
                    )),
                  ], // 여기가 Row
                ),
              ),
            ),
          ),
          Positioned(
              top: 3,
              right: 15,
              child: IconButton(
                icon: Icon(
                  Icons.cancel_outlined,
                  color: Color(0xFFFF6961),
                  size: 32,
                ),
                onPressed: () {
                  customShowDialog(context);
                },
              )),
        ],
      ),
    );
  }

  Future<dynamic> customShowDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('삭제'),
          content: Text('정말 ${widget.itemName} 약을 삭제하시겠습니까?'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('취소'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFFF6961),
              ),
              onPressed: () {
                // 함수 실행 코드 작성
                deletePill();

                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                // Navigator.of(context).popAndPushNamed(routeName);
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const BottomNavigation(where: 3)));
              },
              child: Text('삭제'),
            ),
          ],
        );
      },
    );
  }
}
