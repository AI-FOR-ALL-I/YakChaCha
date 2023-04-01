import 'package:flutter/material.dart';

class TextSearchPillComponent extends StatefulWidget {
  const TextSearchPillComponent({Key? key, this.data}) : super(key: key);
  final Map? data;

  @override
  State<TextSearchPillComponent> createState() =>
      _TextSearchPillComponentState();
}

class _TextSearchPillComponentState extends State<TextSearchPillComponent> {
  var isOverlayOpen = false;

  @override
  Widget build(BuildContext context) {
    print(widget.data);
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
                        widget.data?['img'] == ''
                            ? Image.asset(
                                'assets/images/defaultPill1.png',
                                fit: BoxFit.fitWidth,
                              )
                            : Image.network(
                                '${widget.data?['img']}',
                                fit: BoxFit.fitWidth,
                              ),
                        if (widget.data?['collide'] ||
                            widget.data?['warnPregnant'] ||
                            widget.data?['warnOld'] ||
                            widget.data?['warnAge'])
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
                        child: Text(
                            '${widget.data?['itemName']}'), // TODO: 이 형식으로 추출하시오
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
                                  widget.data?['warnPregnant']
                                      ? Row(children: [
                                          Text(
                                            '임산부 주의',
                                            style:
                                                TextStyle(color: Colors.white),
                                          )
                                        ])
                                      : Container(),
                                  widget.data?['warnOld']
                                      ? Row(children: [
                                          Text(
                                            '노약자 주의',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ])
                                      : Container(),
                                  widget.data?['warnAge']
                                      ? Row(children: [
                                          Text(
                                            '어린이 주의',
                                            style:
                                                TextStyle(color: Colors.white),
                                          )
                                        ])
                                      : Container(),
                                  widget.data?['collide']
                                      ? Row(children: [
                                          Text(
                                            '충돌 약물 주의',
                                            style:
                                                TextStyle(color: Colors.white),
                                          )
                                        ])
                                      : Container(), // TODO: 여기다가 클릭하면 팝업 같은 걸로 충돌 약물 뜨도록!
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
