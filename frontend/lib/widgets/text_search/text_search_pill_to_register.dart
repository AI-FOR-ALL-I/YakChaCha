import 'package:flutter/material.dart';

class TextSearchPillToRgister extends StatefulWidget {
  TextSearchPillToRgister({super.key});
  @override
  State<TextSearchPillToRgister> createState() =>
      _TextSearchPillToRgisterState();
}

class _TextSearchPillToRgisterState extends State<TextSearchPillToRgister> {
  var isOpen = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(10),
        child: ExpansionTile(
          title: Before(),
          subtitle: Column(
            mainAxisAlignment: MainAxisAlignment.center,
          ),
          children: [
            Container(
                child: Column(
              children: [Text('여기가 날짜'), Text('태그 선택')],
            ))
          ],
        ),
      ),
    );
  }
}

class Before extends StatelessWidget {
  const Before({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AspectRatio(
          aspectRatio: 310 / 120,
          child: Expanded(
              flex: 3,
              child: Row(
                children: [
                  Flexible(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.asset('assets/images/night.png',
                            fit: BoxFit.cover),
                      ),
                      flex: 2),
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
                      flex: 3)
                ],
              )),
        ),
      ],
    );
  }
}
