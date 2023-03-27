// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:frontend/screens/pill_details/pill_details.dart';
import 'package:frontend/widgets/common/tag_widget.dart';

class RenewMyPill extends StatelessWidget {
  final String id, name, picture;
  final List title;

  const RenewMyPill({
    super.key,
    required this.id,
    required this.name,
    required this.picture,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PillDetails(),
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
                    child: Image.network(
                      picture,
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
                              child: Text(name,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(fontSize: 15)),
                            )
                          ]),
                    ),
                    Row(
                      children: title
                          .map((tagInfo) => TagWidget(
                              tagName: tagInfo[0] as String,
                              colorIndex: tagInfo[1] as int))
                          .toList(),
                    )
                  ],
                ),
              )),
              Container(
                  child: Column(
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
