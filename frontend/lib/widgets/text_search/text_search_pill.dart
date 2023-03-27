import 'package:flutter/material.dart';

class TextSearchPillComponent extends StatefulWidget {
  const TextSearchPillComponent({super.key});

  @override
  State<TextSearchPillComponent> createState() =>
      _TextSearchPillComponentState();
}

class _TextSearchPillComponentState extends State<TextSearchPillComponent> {
  var isOverlayOpen = false;

  @override
  Widget build(BuildContext context) {
    bool isWarning = true;
    return AspectRatio(
      aspectRatio: 1.2 / 1,
      child: Container(
        margin: EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.red),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Stack(
            children: [
              Column(
                children: [
                  Flexible(
                    flex: 2,
                    child: Stack(
                      children: [
                        Image.asset(
                          'assets/images/pills.png',
                          fit: BoxFit.cover,
                        ),
                        if (isWarning)
                          Positioned(
                            top: 10,
                            right: 10,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  isOverlayOpen = true;
                                });
                              },
                              child: Icon(
                                Icons.warning_amber,
                                color: Colors.red,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Container(
                      constraints: BoxConstraints(
                        minHeight: 0,
                        maxHeight: double.infinity,
                      ),
                      child: Center(
                        child: Text('약이름'),
                      ),
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              isOverlayOpen
                  ? Positioned.fill(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isOverlayOpen = false;
                          });
                        },
                        child: Container(
                          color: Colors.black.withOpacity(0.5),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(children: [
                                    Text(
                                      '임산부 주의',
                                      style: TextStyle(color: Colors.white),
                                    )
                                  ]),
                                  Row(children: [
                                    Text(
                                      '노약자 주의',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ]),
                                  Row(children: [
                                    Text(
                                      '어린이 주의',
                                      style: TextStyle(color: Colors.white),
                                    )
                                  ]),
                                  Row(children: [
                                    Text(
                                      '충돌 약물 주의',
                                      style: TextStyle(color: Colors.white),
                                    )
                                  ]),
                                ]),
                          ),
                        ),
                      ),
                    )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }
}
