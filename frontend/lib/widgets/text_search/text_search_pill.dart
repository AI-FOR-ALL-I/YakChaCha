import 'package:flutter/material.dart';

class TextSearchPillComponent extends StatelessWidget {
  const TextSearchPillComponent({super.key});

  @override
  Widget build(BuildContext context) {
    bool isWarning = true; // 여기가 아이콘 표시여부
    return AspectRatio(
        aspectRatio: 1.2 / 1,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Container(
              decoration: BoxDecoration(border: Border.all(color: Colors.red)),
              child: Column(
                children: [
                  Flexible(
                      child: Stack(children: [
                        Image.asset('assets/images/pills.png'),
                        if (isWarning)
                          Positioned(
                              child:
                                  Icon(Icons.warning_amber, color: Colors.red),
                              top: 10,
                              right: 10)
                      ]),
                      flex: 2),
                  Flexible(
                      child: Expanded(
                        child: Container(
                            constraints: BoxConstraints(
                                minHeight: 0, maxHeight: double.infinity),
                            child: Center(child: Text('약이름')),
                            color: Colors.green),
                      ),
                      flex: 1)
                ],
              )),
        ));
  }
}
