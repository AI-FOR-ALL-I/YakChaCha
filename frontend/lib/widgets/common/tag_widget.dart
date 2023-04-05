import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class TagWidget extends StatelessWidget {
  // 태그명과 색깔 인덱스를 받아올 것
  TagWidget({Key? key, required this.tagName, required this.colorIndex})
      : super(key: key);
  final String tagName;
  final int colorIndex;
  final colorPalette = {
    0: Color(0xffffb1b1),
    1: Color(0xffb7d1e5),
    2: Color(0xffbbe4cb),
    3: Color(0xffffe6b2),
    4: Color(0xff434E71)
  };
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(3, 0, 3, 0),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.15,
          maxHeight: MediaQuery.of(context).size.width * 0.0725,
        ),
        width: MediaQuery.of(context).size.width * 0.15,
        height: MediaQuery.of(context).size.width * 0.0725,
        decoration: BoxDecoration(
            color: colorPalette[colorIndex],
            borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(5, 3, 5, 3),
          child: Center(
            child: AutoSizeText(
              tagName,
              style: TextStyle(color: Colors.white),
              maxLines: 1,
              maxFontSize: 14,
              minFontSize: 8,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
    );
  }
}
