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
                  return Padding(
                    padding: const EdgeInsets.only(
                        left: 10.0, top: 15.0, right: 5.0, bottom: 15.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.asset('assets/images/sampletips.jpg',
                          width: 120, height: 120, fit: BoxFit.cover),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
