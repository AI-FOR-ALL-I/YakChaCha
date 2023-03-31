import 'package:flutter/material.dart';
import 'package:frontend/widgets/common/simple_app_bar.dart';
import 'package:frontend/widgets/common/text_field.dart';

class EmailConfirmPage extends StatefulWidget {
  const EmailConfirmPage({super.key});

  @override
  State<EmailConfirmPage> createState() => _EmailConfirmPageState();
}

class _EmailConfirmPageState extends State<EmailConfirmPage> {
  String email = '';
  void updateEmail(String? newEmail) {
    setState(() {
      email = newEmail ?? '';
    });
  }

  void sendDataToServer(BuildContext context) async {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SimpleAppBar(title: '이메일 확인하기'),
      body: Stack(
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Padding(
              padding: EdgeInsets.only(
                  left: 8.0, top: 15.0, right: 8.0, bottom: 5.0),
              child: Text('상대방의 카카오계정\n이메일을 입력해주세요',
                  style: TextStyle(fontSize: 20.0, color: Colors.black54)),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 8.0, top: 15.0, right: 8.0, bottom: 5.0),
              child: TextFieldComponent(
                  hintText: 'yakchacha@gmail.com', onChanged: updateEmail),
            ),
          ]),
          Positioned(
            left: 0,
            right: 0,
            bottom: 16,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: InkWell(
                onTap: () {
                  // 서버통신진행
                  //sendDataToServer(context);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 32,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: const Color(0xFFBBe4CB),
                      width: 2,
                    ),
                    color: const Color(0xFFBBe4CB),
                  ),
                  child: const Text(
                    '등록하기',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
