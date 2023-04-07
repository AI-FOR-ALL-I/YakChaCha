import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/controller/alarm_pill_controller.dart';
import 'package:frontend/widgets/common/tag_widget.dart';
import 'package:frontend/controller/pill_register_controller.dart';
import 'package:get/get.dart';

class TagPicker extends StatefulWidget {
  const TagPicker({Key? key, required this.seq, required this.isRegister})
      : super(key: key);
  final int seq;
  final bool isRegister;

  @override
  State<TagPicker> createState() => _TagPickerState();
}

class _TagPickerState extends State<TagPicker> {
  List<List<Object>> selectedTagList = [];

  ScrollController _scrollController = ScrollController();

  TextEditingController tagController = TextEditingController();
  String newTag = '';
  @override
  void initState() {
    super.initState();
    PillRegisterController pillRegisterController =
        Get.put<PillRegisterController>(PillRegisterController());
    pillRegisterController.getTagList();
  }

  @override
  void dispose() {
    super.dispose();
    AlarmPillController alarmPillController =
        Get.put<AlarmPillController>(AlarmPillController());
    alarmPillController.clear();
  }

  @override
  Widget build(BuildContext context) {
    Get.put(PillRegisterController());
    return GetBuilder<PillRegisterController>(builder: (controller) {
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Material(
          elevation: 5.0,
          borderRadius: BorderRadius.circular(20.0),
          child: ExpansionTile(
            title: Row(children: [
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      // if (controller.tagList != null &&
                      //     controller.tagList.isNotEmpty)
                      ...List.generate(
                          controller.registerList
                              .firstWhere((pill) =>
                                  pill['itemSeq'] == widget.seq)['tagList']
                              .length, (i) {
                        List tempList = controller.registerList.firstWhere(
                            (pill) => pill['itemSeq'] == widget.seq)['tagList'];
                        String tagName = tempList[i][0] as String;
                        String colorIndex = tempList[i][1].toString() as String;
                        return Row(
                          children: [
                            TagWidget(
                                tagName: tagName,
                                colorIndex: int.parse(colorIndex)),
                            GestureDetector(
                              onTap: () {
                                controller.deleteTag(widget.seq, tagName);
                              },
                              child: Icon(
                                Icons.highlight_off_outlined,
                              ),
                            ),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Dialog(
                          child: Container(
                            // height: 200.0,
                            // width: MediaQuery.of(context).size.width * 0.8,
                            child: TextField(
                              controller: tagController,
                              onChanged: (value) {
                                setState(() {
                                  newTag = value;
                                });
                              },
                              onSubmitted: (value) {
                                if (value != '' && value != null) {
                                  controller.addNewTag(widget.seq, newTag,
                                      controller.tagList.length % 5);
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    _scrollController.animateTo(
                                      _scrollController
                                          .position.maxScrollExtent,
                                      duration: Duration(milliseconds: 200),
                                      curve: Curves.easeInOut,
                                    );
                                  });
                                  setState(() {
                                    newTag = '';
                                  });
                                  tagController.clear();
                                  Navigator.pop(context);
                                }
                              },
                            ),
                          ),
                        );
                      });
                },
                child: Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    children: [
                      Text('새 태그'),
                      Icon(
                        Icons.add,
                      ),
                    ],
                  ),
                ),
              ),
            ]),
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: GridView.builder(
                    itemCount: controller.tagList.length,
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        mainAxisSpacing: 5,
                        // crossAxisSpacing: 5,
                        childAspectRatio: MediaQuery.of(context).size.width *
                            0.15 /
                            (MediaQuery.of(context).size.width * 0.0725)),
                    itemBuilder: (BuildContext context, int i) {
                      List tagList = controller.tagList;
                      String tagName = tagList[i]["name"] as String;
                      String colorIndex =
                          tagList[i]["color"].toString() as String;
                      return GestureDetector(
                        onTap: () {
                          controller.addTag(
                              widget.seq, tagName, int.parse(colorIndex));
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            _scrollController.animateTo(
                              _scrollController.position.maxScrollExtent,
                              duration: Duration(milliseconds: 200),
                              curve: Curves.easeInOut,
                            );
                          });
                        },
                        child: SizedBox(
                            height: MediaQuery.of(context).size.width * 0.07,
                            child: TagWidget(
                                tagName: tagName,
                                colorIndex: int.parse(colorIndex))),
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
