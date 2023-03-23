import 'package:flutter/material.dart';

class MyDrugItem extends StatelessWidget {
  final String imagePath;
  final String title;
  const MyDrugItem({
    super.key,
    required this.imagePath,
    required this.title,
  });

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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                ),
                child: Image.asset(imagePath, fit: BoxFit.fitWidth),
              ),
            ),
            const SizedBox(height: 10.0),
            Text(title),
            // 태그 들어가야한다...
          ],
        ),
      ),
    );
  }
}
