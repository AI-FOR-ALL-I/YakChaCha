import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:frontend/widgets/common/tag_picker.dart';
import 'package:frontend/controller/pill_register_controller.dart';
import 'package:get/get.dart';

class TextSearchPillToRgister extends StatefulWidget {
  const TextSearchPillToRgister({Key? key, required this.data})
      : super(key: key);
  final Map data;

  // {itemSeq: 2, itemName: 12, img: https://nedrug.mfds.go.kr/pbp/cmn/itemImageDownload/151317992996500014, type_code: null, collide: false, warnPregnant: false, warnOld: false, warnAge: false, collide_list: []}

  @override
  State<TextSearchPillToRgister> createState() =>
      _TextSearchPillToRgisterState();
}

class _TextSearchPillToRgisterState extends State<TextSearchPillToRgister> {
  @override
  Widget build(BuildContext context) {
    Get.put(PillRegisterController());
    return GetBuilder<PillRegisterController>(
        tag: "registerController",
        builder: (controller) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Material(
              elevation: 5,
              borderRadius: BorderRadius.circular(10),
              child: ExpansionTile(
                title: Before(data: widget.data),
                subtitle: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                ),
                children: [
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () {
                              showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(DateTime.now().year - 5),
                                lastDate: DateTime(DateTime.now().year + 5),
                              ).then((selectedDate) {
                                if (selectedDate != null) {
                                  controller.updateStartDate(
                                      widget.data['itemSeq'],
                                      DateFormat('yyyy-MM-dd')
                                          .format(selectedDate));
                                }
                              });
                            },
                            child: Row(
                              children: [
                                Icon(
                                  Icons.date_range_outlined,
                                ),
                                Text(
                                  '${controller.registerList.firstWhere((pill) => pill['itemSeq'] == widget.data['itemSeq'])['startDate']} 부터',
                                  style: TextStyle(fontSize: 15),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              showDatePicker(
                                context: context,
                                initialDate:
                                    DateTime.now().add(Duration(days: 7)),
                                firstDate: DateTime(DateTime.now().year - 5),
                                lastDate: DateTime(DateTime.now().year + 5),
                              ).then((selectedDate) {
                                if (selectedDate != null) {
                                  controller.updateEndDate(
                                      widget.data['itemSeq'],
                                      DateFormat('yyyy-MM-dd')
                                          .format(selectedDate));
                                }
                              });
                            },
                            child: Row(
                              children: [
                                Icon(
                                  Icons.date_range_outlined,
                                ),
                                Text(
                                  '${controller.registerList.firstWhere((pill) => pill['itemSeq'] == widget.data['itemSeq'])['endDate']} 까지',
                                  style: TextStyle(fontSize: 15),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      TagPicker(seq: widget.data['itemSeq'], isRegister: true)
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }
}

class Before extends StatelessWidget {
  const Before({Key? key, required this.data}) : super(key: key);
  final Map data;
  @override
  Widget build(BuildContext context) {
    var flagImg = true;
    if (data["img"] == 'assets/images/defaultPill1.png' || data["img"] == "") {
      flagImg = false;
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.width * (0.8 / 3),
          child: Expanded(
              flex: 3,
              child: Row(
                children: [
                  Flexible(
                      flex: 2,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: flagImg
                              ? Image.network('${data['img']}',
                                  fit: BoxFit.cover)
                              : Image.asset('assets/images/defaultPill1.png',
                                  fit: BoxFit.cover))),
                  Flexible(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 5.0),
                              child: Text(
                                '${data['itemName']}',
                                textAlign: TextAlign.left,
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                                maxLines: 2,
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
                                              color: data['warnPregnant']
                                                  ? Colors.red
                                                  : Colors.grey),
                                        ),
                                        const Text(' | '),
                                        Text('노약자 주의',
                                            style: TextStyle(
                                                color: data['warnOld']
                                                    ? Colors.red
                                                    : Colors.grey))
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text('어린이 주의',
                                            style: TextStyle(
                                                color: data['warnAge']
                                                    ? Colors.red
                                                    : Colors.grey)),
                                        const Text(' | '),
                                        Text('충돌 주의',
                                            style: TextStyle(
                                                color: data['collide']
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
                      ))
                ],
              )),
        ),
      ],
    );
  }
}
