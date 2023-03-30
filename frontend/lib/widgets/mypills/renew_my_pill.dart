// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:frontend/screens/pill_details/pill_details_for_api.dart';
import 'package:frontend/widgets/common/tag_widget.dart';

class RenewMyPill extends StatelessWidget {
  final String itemName, img;
  final int itemSeq;
  final List tag_list;
  final bool isTaken;
  const RenewMyPill({
    super.key,
    required this.itemSeq,
    required this.itemName,
    required this.img,
    required this.tag_list,
    required this.isTaken,
  });

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
              builder: (context) => PillDetailsForApi(num: itemSeq.toString()),
            ));
      },
      child: AspectRatio(
        aspectRatio: 3 / 1,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
          padding: const EdgeInsets.all(15),
          // height: 100,
          decoration: const BoxDecoration(
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
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    child: imgFlag
                        ? Image.asset(
                            'assets/images/defalutPill1.png',
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
                    Row(
                      children: tag_list
                          .map((tagInfo) => TagWidget(
                              tagName: tagInfo[0],
                              colorIndex: int.parse(tagInfo[1])))
                          .toList(),
                    )
                  ],
                ),
              )),
              Container(
                  child: isTaken
                      ? SizedBox()
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [Text('d-3')],
                        )),
            ], // 여기가 Row
          ),
        ),
      ),
    );
  }
}
