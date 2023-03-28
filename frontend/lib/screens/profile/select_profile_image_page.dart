import 'package:flutter/material.dart';
import 'package:frontend/widgets/common/simple_app_bar.dart';

class SelectProfileImagePage extends StatefulWidget {
  const SelectProfileImagePage({super.key});

  @override
  State<SelectProfileImagePage> createState() => _SelectProfileImagePageState();
}

class _SelectProfileImagePageState extends State<SelectProfileImagePage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: SimpleAppBar(title: '이미지 선택하기'),
      body: Column(
        children: [Text('프로필 사진 선택하는 화면')],
      ),
    );
  }
}
