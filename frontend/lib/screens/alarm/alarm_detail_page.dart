import 'package:flutter/material.dart';
import 'package:frontend/widgets/mypills/my_pill.dart';
import 'package:frontend/widgets/common/simple_app_bar.dart';
import 'package:frontend/widgets/common/tag_widget.dart';

class AlarmDetailPage extends StatelessWidget {
  const AlarmDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(title: '알람 설정'),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(15)),
              child: AspectRatio(
                aspectRatio: 311 / 118,
                child: Stack(
                  children: [
                    Container(
                        child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Text(
                                  '01:30',
                                  style: TextStyle(fontSize: 40),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    'PM',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              ]),
                          Row(children: [
                            TagWidget(tagName: '태그명', colorIndex: 1),
                            TagWidget(tagName: '태그명', colorIndex: 2),
                          ])
                        ],
                      ),
                    )),
                    Align(
                        alignment: AlignmentDirectional.topEnd,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Icon(
                            Icons.settings_outlined,
                          ),
                        ))
                  ],
                ),
              ),
            ),
          ),
          Expanded(
              child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30)),
                color: Theme.of(context).colorScheme.primary),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text('총 ${3}정 | ${2} 종류'),
                ),
                ListView.builder(
                    itemCount: 10,
                    shrinkWrap: true,
                    itemBuilder: ((context, index) {
                      return MyPill(); // TODO: MyPill이 안나오는 문제는 동준이한테 물어보기
                    }))
              ],
            ),
          ))
        ],
      ),
    );
  }
}
