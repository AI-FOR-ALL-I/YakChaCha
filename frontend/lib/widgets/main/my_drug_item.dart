import 'package:flutter/material.dart';

class MyDrugItem extends StatelessWidget {
  final String imagePath;
  final String title;
  const MyDrugItem({
    // CHANGED: Key type is updated to Key?.
    Key? key,
    required this.imagePath,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 15.0),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFFF8EA),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Flex(
          direction: Axis.vertical,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                ),
                // CHANGED: The fit property of the Image.asset is set to BoxFit.fitWidth.
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                      decoration: BoxDecoration(
                          color: Colors.pink,
                          border: Border.all(
                            color: Colors.pink,
                          ),
                          borderRadius: BorderRadius.circular(15)),
                      child: const Text('태그명 1')),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(title),
            ),
            // 태그 들어가야한다...
          ],
        ),
      ),
    );
  }
}
