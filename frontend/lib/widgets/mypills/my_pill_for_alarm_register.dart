import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:frontend/screens/pill_details/pill_details_for_api.dart';
import 'package:frontend/widgets/common/tag_widget.dart';
import 'package:get/get.dart';
import 'package:frontend/controller/alarm_pill_controller.dart';

class MyPillForAlarmRegister extends StatefulWidget {
  const MyPillForAlarmRegister({Key? key, required this.data})
      : super(key: key);
  final Map data;

  @override
  State<MyPillForAlarmRegister> createState() => _MyPillState();
}

class _MyPillState extends State<MyPillForAlarmRegister> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  PillDetailsForApi(num: widget.data['medicineSeq'].toString()),
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
                  child: widget.data['img'] != ""
                      ? Image.network(widget.data['img'])
                      : Image.asset('assets/images/pills.png')),
              Flexible(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Flexible(
                                child: Text(widget.data["itemName"],
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(fontSize: 15)),
                              )
                            ]),
                      ),
                      Row(
                        children: List<Widget>.from(widget.data["tagList"].map(
                            (tagInfo) => TagWidget(
                                tagName: tagInfo[0] as String,
                                colorIndex: int.parse(tagInfo[1])))),
                      )
                    ],
                  )),
              GetBuilder<AlarmPillController>(builder: (controller) {
                return Container(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Builder(builder: (context) {
                      return GestureDetector(
                        onTap: () {
                          print(widget.data);
                          controller.changeCount(widget.data["medicineSeq"], 1);
                        },
                        child: Icon(
                          Icons.arrow_drop_up_outlined,
                        ),
                      );
                    }),
                    Text(controller.selectedList
                        .firstWhere((pill) =>
                            pill["medicineSeq"] ==
                            widget.data["medicineSeq"])["count"]
                        .toString()),
                    GestureDetector(
                      onTap: () {
                        controller.changeCount(widget.data["medicineSeq"], -1);
                      },
                      child: Icon(
                        Icons.arrow_drop_down_outlined,
                      ),
                    ),
                  ],
                ));
              }),
            ], // 여기가 Row
          ),
        ),
      ),
    );
  }
}
