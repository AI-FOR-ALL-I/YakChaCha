import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/widgets/common/tag_widget.dart';
import 'package:frontend/controller/alarm_pill_controller.dart';
import 'package:get/get.dart';

class TagPickerForAlarmPage extends StatefulWidget {
  const TagPickerForAlarmPage({Key? key}) : super(key: key);

  @override
  State<TagPickerForAlarmPage> createState() => _TagPickerForAlarmPageState();
}

class _TagPickerForAlarmPageState extends State<TagPickerForAlarmPage> {
  List<List<Object>> selectedTagList = [];
  // List<List<Object>> tagList = [
  //   ['태그명1', '1'],
  //   ['태그명2', '2'],
  //   ['태그명3', '3'],
  //   ['태그명4', '4'],
  // ]; // TODO: props 혹은 Dio로 태그 다 받아오기

  AlarmPillController controller = Get.find();
  @override
  void initState() {
    super.initState();
    controller.getTagList();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AlarmPillController>(builder: (controller) {
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Material(
          elevation: 5.0,
          borderRadius: BorderRadius.circular(20.0),
          child: ExpansionTile(
            title: GestureDetector(
              onTap: () {},
              child: Row(children: [
                Row(
                  children: [
                    // ...List.generate(
                    //     controller.registerList
                    //         .firstWhere((pill) =>
                    //             pill['itemSeq'] == widget.seq)['tagList']
                    //         .length, (i) {
                    //   List tempList = controller.registerList.firstWhere(
                    //       (pill) => pill['itemSeq'] == widget.seq)['tagList'];
                    //   String tagName = tempList[i][0] as String;
                    //   String colorIndex = tempList[i][1].toString() as String;
                    //   return Row(
                    //     children: [
                    //       TagWidget(
                    //           tagName: tagName,
                    //           colorIndex: int.parse(colorIndex)),
                    //       GestureDetector(
                    //         onTap: () {
                    //         },
                    //         child: Icon(
                    //           Icons.highlight_off_outlined,
                    //         ),
                    //       ),
                    //     ],
                    //   );
                    // }),
                  ],
                ),
              ]),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: GridView.builder(
                    itemCount: controller.tagList.length,
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        // mainAxisSpacing: 10,
                        // crossAxisSpacing: 10,
                        childAspectRatio: MediaQuery.of(context).size.width *
                            0.15 /
                            (MediaQuery.of(context).size.width * 0.0725)),
                    itemBuilder: (BuildContext context, int i) {
                      String tagName = controller.tagList[i]["name"] as String;
                      int colorIndex = controller.tagList[i]["color"] as int;
                      return GestureDetector(
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 5.0),
                          child: SizedBox(
                              height: MediaQuery.of(context).size.width * 0.07,
                              child: TagWidget(
                                  tagName: tagName, colorIndex: colorIndex)),
                        ),
                      );
                    }),
              )
            ],
          ),
        ),
      );
    });
  }
}
