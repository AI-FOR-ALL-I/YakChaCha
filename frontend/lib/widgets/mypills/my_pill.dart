import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:frontend/screens/pill_details/pill_details.dart';
import 'package:frontend/widgets/common/tag_widget.dart';

class MyPill extends StatefulWidget {
  const MyPill({Key? key, required this.isAlarmRegister}) : super(key: key);
  final bool isAlarmRegister;

  @override
  State<MyPill> createState() => _MyPillState();
}

class _MyPillState extends State<MyPill> {
  int pillCount = 1;

  @override
  Widget build(BuildContext context) {
    List<List<Object>> tagList = [
      ['태그명1', 1],
      ['태그명2', 2],
    ];
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
              Container(
                  clipBehavior: Clip.hardEdge,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  child: Image.asset(
                    'assets/images/pills.png',
                  )), // 이미지
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Flexible(
                            child: Text('넬슨이부프로펜정dasdasd',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(fontSize: 15)),
                          )
                        ]),
                  ),
                  Row(
                    children: tagList
                        .map((List<Object> tagInfo) => TagWidget(
                            tagName: tagInfo[0] as String,
                            colorIndex: tagInfo[1] as int))
                        .toList(),
                  )
                ],
              )),
              Container(
                  child: widget.isAlarmRegister
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  pillCount++;
                                });
                              },
                              child: Icon(
                                Icons.arrow_drop_up_outlined,
                              ),
                            ),
                            Text('${pillCount}'),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (pillCount > 1) {
                                    pillCount--;
                                  }
                                });
                              },
                              child: Icon(
                                Icons.arrow_drop_down_outlined,
                              ),
                            ),
                          ],
                        )
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
