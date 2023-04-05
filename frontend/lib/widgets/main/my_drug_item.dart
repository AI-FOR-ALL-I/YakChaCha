import 'package:flutter/material.dart';
import 'package:frontend/widgets/common/tag_widget.dart';

class MyDrugItem extends StatelessWidget {
  final String imagePath, title;
  final List tag_list;
  const MyDrugItem({
    // CHANGED: Key type is updated to Key?.
    super.key,
    required this.imagePath,
    required this.title,
    required this.tag_list,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 15.0),
      child: Container(
        width: 200,
        decoration: BoxDecoration(
          color: const Color(0xFFF8F2E6),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          children: [
            Flexible(
              flex: 5,
              child: SizedBox(
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0),
                  ),
                  // CHANGED: The fit property of the Image.asset is set to BoxFit.fitWidth.
                  child: imagePath == ''
                      ? Image.asset('assets/images/defaultPill1.png',
                          fit: BoxFit.fill)
                      : Image.network(imagePath, fit: BoxFit.fill),
                ),
              ),
            ),
            Flexible(
                flex: 3,
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.all(10),
                      alignment: Alignment.centerLeft,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: tag_list
                              .map((tagInfo) => TagWidget(
                                  tagName: tagInfo["name"],
                                  colorIndex: tagInfo["color"]))
                              .toList(),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 14),
                      child: Text(
                        title,
                        style: TextStyle(fontSize: 20),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    )
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
