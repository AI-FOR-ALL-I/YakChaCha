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

  AlarmPillController controller = Get.find();
  @override
  void initState() {
    super.initState();
    controller.getTagList();
  }

  @override
  Widget build(BuildContext context) {
    Get.put(AlarmPillController());
    return GetBuilder<AlarmPillController>(builder: (controller) {
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Material(
          elevation: 5.0,
          borderRadius: BorderRadius.circular(20.0),
          child: ExpansionTile(
            title: GridView.builder(
                itemCount: controller.selectedTagList.length,
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    // mainAxisSpacing: 10,
                    // crossAxisSpacing: 10,
                    childAspectRatio: MediaQuery.of(context).size.width *
                        0.15 /
                        (MediaQuery.of(context).size.width * 0.0725)),
                itemBuilder: (BuildContext context, int i) {
                  String tagName =
                      controller.selectedTagList[i]["name"] as String;
                  int colorIndex =
                      controller.selectedTagList[i]["color"] as int;
                  int tagSeq = controller.selectedTagList[i]["tagSeq"] as int;
                  return GestureDetector(
                    onTap: () {
                      controller.updateTagList(tagSeq, tagName, colorIndex);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 5.0),
                      child: SizedBox(
                          height: MediaQuery.of(context).size.width * 0.07,
                          child: TagWidget(
                              tagName: tagName, colorIndex: colorIndex)),
                    ),
                  );
                }),
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: GridView.builder(
                    itemCount: controller.tagList.length,
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        mainAxisSpacing: 5,
                        // crossAxisSpacing: 10,
                        childAspectRatio: MediaQuery.of(context).size.width *
                            0.15 /
                            (MediaQuery.of(context).size.width * 0.0725)),
                    itemBuilder: (BuildContext context, int i) {
                      String tagName = controller.tagList[i]["name"] as String;
                      int colorIndex = controller.tagList[i]["color"] as int;
                      int tagSeq = controller.tagList[i]["tagSeq"] as int;
                      return GestureDetector(
                        onTap: () {
                          controller.updateTagList(tagSeq, tagName, colorIndex);
                        },
                        child: SizedBox(
                            height: MediaQuery.of(context).size.width * 0.07,
                            child: TagWidget(
                                tagName: tagName, colorIndex: colorIndex)),
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
