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
    return Padding(
      padding: const EdgeInsets.all(12),
      child: AspectRatio(
        aspectRatio: 1.2 / 1,
        child: Material(
          elevation: 5,
          borderRadius: BorderRadius.circular(15),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 2,
                      child: Stack(
                        children: [
                          widget.data?['img'] == ''
                              ? Image.asset(
                                  'assets/images/defaultPill1.png',
                                  fit: BoxFit.fill,
                                )
                              : Image.network(
                                  '${widget.data?['img']}',
                                  fit: BoxFit.fill,
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
                    Expanded(
                      child: Container(
                        constraints: BoxConstraints(
                          minHeight: 0,
                          maxHeight: double.infinity,
                        ),
                        child: Text('${widget.data?['itemName']}'),
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
                                              style: TextStyle(
                                                  color: Colors.white),
                                            )
                                          ])
                                        : Container(),
                                    widget.data?['warnOld']
                                        ? Row(children: [
                                            Text(
                                              '노약자 주의',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ])
                                        : Container(),
                                    widget.data?['warnAge']
                                        ? Row(children: [
                                            Text(
                                              '어린이 주의',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            )
                                          ])
                                        : Container(),
                                    widget.data?['collide']
                                        ? Row(children: [
                                            Text(
                                              '충돌 약물 주의',
                                              style: TextStyle(
                                                  color: Colors.white),
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
      ),
    );
  }
}
