import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:frontend/widgets/common/tag_picker.dart';

class TextSearchPillToRgister extends StatefulWidget {
  const TextSearchPillToRgister(
      {Key? key, this.data, required this.setRegisterList})
      : super(key: key);
  final Map? data;
  final Function setRegisterList;

  // {itemSeq: 2, itemName: 12, img: https://nedrug.mfds.go.kr/pbp/cmn/itemImageDownload/151317992996500014, type_code: null, collide: false, warn_pregnant: false, warn_old: false, warn_age: false, collide_list: []}

  @override
  State<TextSearchPillToRgister> createState() =>
      _TextSearchPillToRgisterState();
}

class _TextSearchPillToRgisterState extends State<TextSearchPillToRgister> {
  late bool isOpen = false;
  late Map<String, dynamic> item;
  @override
  void initState() {
    super.initState();

    isOpen = false;
    item = {
      'item_seq': widget.data!['itemSeq'],
      'start_date': DateFormat('yyyy.MM.dd').format(DateTime.now()),
      'end_date': DateFormat('yyyy.MM.dd').format(DateTime.now()),
      'tagList': []
    };
  }

  // TODO: 만약 start_date와 endDate의 크기 비교 필요(둘중 하나를 설정하면, 그거 이전 이후로 나머지의 범위를 설정하느 방법도,...)
  // TODO: 새 태그를 만들었을 시, 태그를 바로 위에 입력되게하는 로직 필요
  setTagList(data) {
    setState(() {
      item['tagList'] = data;
      widget.setRegisterList(item, item['item_seq']);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(10),
        child: ExpansionTile(
          title: Before(data: widget.data),
          subtitle: Column(
            mainAxisAlignment: MainAxisAlignment.center,
          ),
          children: [
            Container(
                child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('${item['start_date']} 부터'),
                    GestureDetector(
                      onTap: () {
                        showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(DateTime.now().year - 5),
                          lastDate: DateTime(DateTime.now().year + 5),
                        ).then((selectedDate) {
                          if (selectedDate != null) {
                            setState(() {
                              item['start_date'] =
                                  DateFormat('yyyy.MM.dd').format(selectedDate);
                            });
                          }
                        });
                      },
                      child: Icon(
                        Icons.date_range_outlined,
                      ),
                    ),
                    Text('${item['end_date']} 까지'),
                    GestureDetector(
                      onTap: () {
                        showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(DateTime.now().year - 5),
                          lastDate: DateTime(DateTime.now().year + 5),
                        ).then((selectedDate) {
                          if (selectedDate != null) {
                            setState(() {
                              item['end_date'] =
                                  DateFormat('yyyy.MM.dd').format(selectedDate);
                            });
                          }
                        });
                      },
                      child: Icon(
                        Icons.date_range_outlined,
                      ),
                    ),
                  ],
                ),
                TagPicker(setTagList: setTagList, isRegister: true)
              ],
            ))
          ],
        ),
      ),
    );
  }
}

class Before extends StatelessWidget {
  const Before({Key? key, this.data}) : super(key: key);
  final Map? data;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.width * (0.8 / 3),
          child: Expanded(
              flex: 3,
              child: Row(
                children: [
                  Flexible(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: data?['img'] != null
                            ? Image.network('${data?['img']}',
                                fit: BoxFit.cover)
                            : Image.asset('assets/images/night.png',
                                fit: BoxFit.cover),
                      ),
                      flex: 2),
                  Flexible(
                      child: Container(
                          child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 5.0),
                              child: Text(
                                '${data?['itemName']}',
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          '임산부 주의',
                                          style: TextStyle(
                                              color: data?['warn_pregnant']
                                                  ? Colors.red
                                                  : Colors.grey),
                                        ),
                                        Text(' | '),
                                        Text('노약자 주의',
                                            style: TextStyle(
                                                color: data?['warn_old']
                                                    ? Colors.red
                                                    : Colors.grey))
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text('어린이 주의',
                                            style: TextStyle(
                                                color: data?['warn_age']
                                                    ? Colors.red
                                                    : Colors.grey)),
                                        Text(' | '),
                                        Text('충돌 주의',
                                            style: TextStyle(
                                                color: data?['collide']
                                                    ? Colors.red
                                                    : Colors.grey))
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                      )),
                      flex: 3)
                ],
              )),
        ),
      ],
    );
  }
}
