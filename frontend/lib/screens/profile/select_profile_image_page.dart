import 'package:flutter/material.dart';

class SelectProfileImagePage extends StatelessWidget {
  final List<String> imageList = [
    'assets/images/profile1.png',
    'assets/images/profile2.png',
    'assets/images/profile3.png',
    'assets/images/profile4.png',
    'assets/images/profile5.png',
    'assets/images/profile6.png',
    'assets/images/profile7.png',
    'assets/images/profile8.png',
    'assets/images/profile9.png',
    'assets/images/profile10.png',
  ];

  SelectProfileImagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('프로필 이미지 변경'),
      ),
      body: GridView.builder(
        itemCount: imageList.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              // 이미지 선택 시, 해당 인덱스 값 반환 후 페이지 이동
              Navigator.pop(context, index);
            },
            child: Image.asset(
              imageList[index],
              fit: BoxFit.cover,
            ),
          );
        },
      ),
    );
  }
}
