import 'package:flutter/material.dart';

class TimeHeader extends StatelessWidget {
  final int timeline;

  const TimeHeader({super.key, required this.timeline});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(0.0),
      child: Stack(children: [
        Image.asset(
          'assets/images/mainbuttonpills.png',
          height: 160,
          fit: BoxFit.fill,
        ),
        Container(
            alignment: Alignment.bottomLeft,
            child: const Text(
              'Text Message',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 22.0),
            )),
      ]),
    );
  }
}
