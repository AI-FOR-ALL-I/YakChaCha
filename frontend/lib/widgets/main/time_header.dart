import 'package:flutter/material.dart';

class TimeHeader extends StatelessWidget {
  final int timeline;
  final String nickname;
  const TimeHeader({super.key, required this.timeline, required this.nickname});
  // 새벽이미지도 처리해주어야해.
  // timeline 0.1.2 int값으로 받아서 설정하기..
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(0.0),
      child: Stack(children: [
        Image.asset(
          'assets/images/day.png',
          height: 160,
          fit: BoxFit.cover,
          width: double.infinity,
          color: Colors.black.withOpacity(0.2),
          colorBlendMode: BlendMode.darken,
        ),
        Positioned(
          bottom: 10.0,
          left: 10.0,
          child: Container(
            alignment: Alignment.bottomLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "$nickname님",
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 16.0),
                ),
                const Text(
                  'Text Message',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 16.0),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
