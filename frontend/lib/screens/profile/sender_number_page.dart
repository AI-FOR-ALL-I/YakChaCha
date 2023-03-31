import 'package:flutter/material.dart';
import 'package:frontend/widgets/common/simple_app_bar.dart';
import 'package:frontend/widgets/common/text_field.dart';

class SenderNumberPage extends StatefulWidget {
  const SenderNumberPage({super.key});

  @override
  State<SenderNumberPage> createState() => _SenderNumberPageState();
}

class _SenderNumberPageState extends State<SenderNumberPage> {
  String veritfyCode = '';
  void updateCode(String? newCode) {
    setState(() {
      veritfyCode = newCode ?? '';
    });
  }

  // 서버통신용
  void sendDataToServer(BuildContext context) async {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SimpleAppBar(title: '인증번호 입력'),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(
                    left: 8.0, top: 15.0, right: 8.0, bottom: 5.0),
                child: Text('인증번호를 등록해주세요.',
                    style: TextStyle(fontSize: 20.0, color: Colors.black54)),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 8.0, top: 15.0, right: 8.0, bottom: 5.0),
                child: TextFieldComponent(
                    hintText: '상대방 화면의 인증번호 6자리 입력', onChanged: updateCode),
              ),
            ],
          ),
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
                  // 인증번호 입력하는 화면으로 이동시키기
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SenderNumberPage()));
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
