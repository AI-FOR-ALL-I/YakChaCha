import 'package:flutter/material.dart';
import 'package:frontend/widgets/common/simple_app_bar.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SimpleAppBar(title: '사용자 전환'),
      body: Column(
        children: [
          SizedBox(
            height: 150,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (BuildContext context, int index) {
                  return Image.asset('assets/images/sampletips.jpg',
                      width: 80, height: 80, fit: BoxFit.fill);
                }),
          ),
        ],
      ),
    );
  }
}
