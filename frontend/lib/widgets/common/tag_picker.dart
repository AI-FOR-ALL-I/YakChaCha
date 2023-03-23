import 'package:flutter/material.dart';
import 'package:textfield_tags/textfield_tags.dart';
import 'package:frontend/widgets/common/tag_widget.dart';

class TagPicker extends StatefulWidget {
  TagPicker({super.key});

  @override
  State<TagPicker> createState() => _TagPickerState();
}

class _TagPickerState extends State<TagPicker> {
  List<List<Object>> selectedTagList = [
    ['태그명1', 1],
    ['태그명2', 2]
  ];
  List<List<Object>> tagList = [
    ['태그명1', 1],
    ['태그명2', 2],
    ['태그명3', 3],
    ['태그명4', 4],
  ];
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Row(
        children: List.generate(selectedTagList.length, (i) {
          String tagName = selectedTagList[i][0] as String;
          int colorIndex = selectedTagList[i][1] as int;
          return TagWidget(tagName: tagName, colorIndex: colorIndex);
        }),
      ),
      children: [
        GridView.builder(
            itemCount: tagList.length,
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                // mainAxisSpacing: 10,
                // crossAxisSpacing: 10,
                childAspectRatio: MediaQuery.of(context).size.width *
                    0.2 /
                    (MediaQuery.of(context).size.width * 0.07)),
            itemBuilder: (BuildContext context, int i) {
              String tagName = tagList[i][0] as String;
              int colorIndex = tagList[i][1] as int;
              return SizedBox(
                  height: MediaQuery.of(context).size.width * 0.07,
                  child: TagWidget(tagName: tagName, colorIndex: colorIndex));
            })
      ],
    );
  }
}
