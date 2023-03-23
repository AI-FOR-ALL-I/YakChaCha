import 'package:flutter/material.dart';

class TagWidget extends StatelessWidget {
  // 태그명과 색깔 인덱스를 받아올 것
  TagWidget({Key? key, required this.tagName, required this.colorIndex})
      : super(key: key);
  final String tagName;
  final int colorIndex;
  final colorPalette = {
    1: Color(0xffffb1b1),
    2: Color(0xffb7d1e5),
    3: Color(0xffbbe4cb),
    4: Color(0xffffe6b2),
  };
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(3, 0, 3, 0),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.2,
        height: MediaQuery.of(context).size.width * 0.07,
        decoration: BoxDecoration(
            color: colorPalette[colorIndex],
            borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(5, 3, 5, 3),
          child: Center(
            child: Text(
              tagName,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
