// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:frontend/screens/pill_details/pill_details_for_api.dart';
import 'package:frontend/widgets/common/tag_widget.dart';

class RenewMyPill extends StatelessWidget {
  final String itemName, img;
  final int itemSeq, dday;
  final List tag_list;
  final bool isTaken;
  final bool? isSelected;
  const RenewMyPill(
      {super.key,
      required this.itemSeq,
      required this.itemName,
      required this.img,
      required this.tag_list,
      required this.dday,
      required this.isTaken,
      this.isSelected});

  @override
  Widget build(BuildContext context) {
    var imgFlag = false;
    if (img == "") {
      imgFlag = true;
    }
    // List<List<Object>> tags = [
    //   ['태그명1', 1],
    //   ['태그명2', 2],
    // ];
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  PillDetailsForApi(turnOnPlus: false, num: itemSeq.toString()),
            ));
      },
      child: AspectRatio(
        aspectRatio: 3 / 1,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
          padding: const EdgeInsets.all(15),
          // height: 100,
          decoration: BoxDecoration(
            border: Border.all(
                color: isSelected != null && isSelected == true
                    ? Colors.green
                    : Colors.transparent,
                width: 2.0),
            boxShadow: [
              BoxShadow(
                  offset: Offset(1, 1), blurRadius: 2, color: Colors.black12)
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
                        : Image.network(
                            img,
                            fit: BoxFit.fill,
                          )),
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
                              child: Text(itemName,
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
                          children: tag_list
                                    .map((tagInfo) => TagWidget(
                                        tagName: tagInfo["tagName"],
                                        colorIndex: tagInfo["tagColor"]))
                                    .toList(),
                        ),
                      ),
                    )
                  ],
                ),
              )),
              Container(
                  child: isTaken
                      ? SizedBox()
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [Text('d-$dday')],
                        )),
            ], // 여기가 Row
          ),
        ),
      ),
    );
  }
}
