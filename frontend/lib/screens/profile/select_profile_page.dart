import 'package:flutter/material.dart';
import 'package:frontend/widgets/profile/profile_info.dart';

class SelectProfilePage extends StatefulWidget {
  const SelectProfilePage({super.key});

  @override
  _SelectProfilePage createState() => _SelectProfilePage();
}

class _SelectProfilePage extends State<SelectProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('프로필 선택'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: const [
              ProfileInfo(
                  imagePath: 'assets/images/pills.png',
                  title: '유저이름',
                  description: '아세트아미노펜'),
              ProfileInfo(
                  imagePath: 'assets/images/pills.png',
                  title: '타이레놀',
                  description: '아세트아미노펜'),
              ProfileInfo(
                  imagePath: 'assets/images/pills.png',
                  title: '타이레놀',
                  description: '아세트아미노펜'),
              ProfileInfo(
                  imagePath: 'assets/images/pills.png',
                  title: '타이레놀',
                  description: '아세트아미노펜'),
              ProfileInfo(
                  imagePath: 'assets/images/pills.png',
                  title: '타이레놀',
                  description: '아세트아미노펜'),
              ProfileInfo(
                  imagePath: 'assets/images/pills.png',
                  title: '타이레놀',
                  description: '아세트아미노펜'),
              ProfileInfo(
                  imagePath: 'assets/images/pills.png',
                  title: '타이레놀',
                  description: '아세트아미노펜'),
              ProfileInfo(
                  imagePath: 'assets/images/pills.png',
                  title: '타이레놀',
                  description: '아세트아미노펜'),
              ProfileInfo(
                  imagePath: 'assets/images/pills.png',
                  title: '타이레놀',
                  description: '아세트아미노펜'),
              ProfileInfo(
                  imagePath: 'assets/images/pills.png',
                  title: '타이레놀',
                  description: '아세트아미노펜'),
            ],
          ),
        ));
  }
}
