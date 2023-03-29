import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  List<List<Object>> tagList = [
    ['태그명1', '1'],
    ['태그명2', '2'],
    ['태그명3', '3'],
    ['태그명4', '4'],
  ]; // TODO: props 혹은 Dio로 태그 다 받아오기

  TextEditingController tagController = TextEditingController();
  String newTag = '';

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
            title: GestureDetector(
              onTap: () {},
              child: Row(children: [
                Row(
                  children: [
                    ...List.generate(controller.registerList.length, (i) {
                      String tagName = controller.registerList[i][0] as String;
                      int colorIndex = controller.registerList[i][1] as int;
                      return Row(
                        children: [
                          TagWidget(tagName: tagName, colorIndex: colorIndex),
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
                    GestureDetector(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
                                child: Container(
                                  // height: 200.0,
                                  // width: MediaQuery.of(context).size.width * 0.8,
                                  //여기는 엔터로 입력하게 하는 코드
                                  child: RawKeyboardListener(
                                    focusNode: FocusNode(),
                                    onKey: (RawKeyEvent event) {
                                      if (event.logicalKey ==
                                          LogicalKeyboardKey.enter) {
                                        controller.addNewTag(widget.seq, newTag,
                                            tagList.length % 4);
                                        setState(() {
                                          newTag = '';
                                        });
                                        Navigator.pop(context);
                                      }
                                    },
                                    child: TextField(
                                      controller: tagController,
                                      onChanged: (value) {
                                        setState(() {
                                          newTag = value;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              );
                            });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20)),
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
                  ],
                ),
              ]),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: GridView.builder(
                    itemCount: tagList.length,
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        // mainAxisSpacing: 10,
                        // crossAxisSpacing: 10,
                        childAspectRatio: MediaQuery.of(context).size.width *
                            0.15 /
                            (MediaQuery.of(context).size.width * 0.0725)),
                    itemBuilder: (BuildContext context, int i) {
                      String tagName = tagList[i][0] as String;
                      String colorIndex = tagList[i][1] as String;
                      return GestureDetector(
                        onTap: () {
                          controller.addTag(
                              widget.seq, tagName, int.parse(colorIndex));
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 5.0),
                          child: SizedBox(
                              height: MediaQuery.of(context).size.width * 0.07,
                              child: TagWidget(
                                  tagName: tagName,
                                  colorIndex: int.parse(colorIndex))),
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
