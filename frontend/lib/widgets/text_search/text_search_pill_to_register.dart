import 'package:flutter/material.dart';

class TextSearchPillToRgister extends StatelessWidget {
  const TextSearchPillToRgister({super.key});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
        aspectRatio: 296 / 101,
        child: Container(
            margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.red),
            ),
            child: Row(
              children: [
                Flexible(
                    child: Container(
                      margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          'assets/images/pills.png',
                        ),
                      ),
                    ),
                    flex: 1),
                Flexible(
                    child: Container(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('약 이름입니다~~~~'),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.warning_amber, color: Colors.red),
                            Row(
                              children: [
                                Text('충돌성분'),
                                Text(' | '),
                                Text('주의사항임')
                              ],
                            )
                          ],
                        )
                      ],
                    )),
                    flex: 2)
              ],
            )));
  }
}
