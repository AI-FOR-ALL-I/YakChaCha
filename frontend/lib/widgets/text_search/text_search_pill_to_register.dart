import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:frontend/widgets/common/tag_picker.dart';
import 'package:frontend/controller/pill_register_controller.dart';
import 'package:get/get.dart';

class TextSearchPillToRgister extends StatefulWidget {
  const TextSearchPillToRgister({Key? key, required this.data})
      : super(key: key);
  final Map data;

  // {itemSeq: 2, itemName: 12, img: https://nedrug.mfds.go.kr/pbp/cmn/itemImageDownload/151317992996500014, type_code: null, collide: false, warn_pregnant: false, warn_old: false, warn_age: false, collide_list: []}

  @override
  State<TextSearchPillToRgister> createState() =>
      _TextSearchPillToRgisterState();
}

class _TextSearchPillToRgisterState extends State<TextSearchPillToRgister> {
  @override
  Widget build(BuildContext context) {
    Get.put(PillRegisterController());
    return GetBuilder<PillRegisterController>(builder: (controller) {
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
                      Text(
                          '${controller.registerList.firstWhere((pill) => pill['item_seq'] == widget.data['item_seq'])['start_date']} 부터'),
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
                                  widget.data['item_seq'],
                                  DateFormat('yyyy-MM-dd')
                                      .format(selectedDate));
                            }
                          });
                        },
                        child: Icon(
                          Icons.date_range_outlined,
                        ),
                      ),
                      Text(
                          '${controller.registerList.firstWhere((pill) => pill['item_seq'] == widget.data['item_seq'])['end_date']} 까지'), // endDate
                      GestureDetector(
                        onTap: () {
                          showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(DateTime.now().year - 5),
                            lastDate: DateTime(DateTime.now().year + 5),
                          ).then((selectedDate) {
                            if (selectedDate != null) {
                              controller.updateEndDate(
                                  widget.data['item_seq'],
                                  DateFormat('yyyy-MM-dd')
                                      .format(selectedDate));
                            }
                          });
                        },
                        child: Icon(
                          Icons.date_range_outlined,
                        ),
                      ),
                    ],
                  ),
                  TagPicker(seq: widget.data['item_seq'], isRegister: true)
                ],
              ))
            ],
          ),
        ),
      );
    });
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
                                '${data?['item_name']}',
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
