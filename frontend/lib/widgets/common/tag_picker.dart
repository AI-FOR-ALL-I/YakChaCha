import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/widgets/common/tag_widget.dart';

class TagPicker extends StatefulWidget {
  const TagPicker({Key? key, this.setTagList, required this.isRegister})
      : super(key: key);
  final Function? setTagList;
  final bool isRegister;

  @override
  State<TagPicker> createState() => _TagPickerState();
}

class _TagPickerState extends State<TagPicker> {
  List<List<Object>> selectedTagList =
      []; // TODO : 여기서 선택된 애들을 한단계 위로 보내서, 태그 선택되면 관련약 전부 선택 되도록 하기
  List<List<Object>> tagList = [
    ['태그명1', 1],
    ['태그명2', 2],
    ['태그명3', 3],
    ['태그명4', 4],
  ]; // TODO: props 혹은 Dio로 태그 다 받아오기

  TextEditingController tagController = TextEditingController();
  String newTag = '';

  @override
  Widget build(BuildContext context) {
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
                  ...List.generate(selectedTagList.length, (i) {
                    String tagName = selectedTagList[i][0] as String;
                    int colorIndex = selectedTagList[i][1] as int;
                    return Row(
                      children: [
                        TagWidget(tagName: tagName, colorIndex: colorIndex),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedTagList.removeAt(i);
                            });
                            if (widget.setTagList != null) {
                              widget.setTagList!(selectedTagList);
                            }
                            ;
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
                                child: RawKeyboardListener(
                                  focusNode: FocusNode(),
                                  onKey: (RawKeyEvent event) {
                                    if (event.logicalKey ==
                                        LogicalKeyboardKey.enter) {
                                      tagList.add(
                                          [newTag, (tagList.length % 4) + 1]);
                                      newTag = '';
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
                    int colorIndex = tagList[i][1] as int;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (!selectedTagList.contains(tagList[i]) &&
                              selectedTagList.length < 2) {
                            selectedTagList.add(tagList[i]);
                          }
                        });
                        if (widget.setTagList != null) {
                          widget.setTagList!(selectedTagList);
                        }
                        ;
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
            )
          ],
        ),
      ),
    );
  }
}
