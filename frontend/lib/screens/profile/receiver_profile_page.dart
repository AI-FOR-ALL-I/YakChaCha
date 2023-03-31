import 'package:flutter/material.dart';
import 'package:frontend/widgets/common/simple_app_bar.dart';

class ReceiverProfilePage extends StatefulWidget {
  const ReceiverProfilePage({super.key});

  @override
  State<ReceiverProfilePage> createState() => _ReceiverProfilePageState();
}

class _ReceiverProfilePageState extends State<ReceiverProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SimpleAppBar(title: '프로필 선택'),
      body: Stack(
        children: [
          const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: EdgeInsets.only(
                  left: 8.0, top: 15.0, right: 8.0, bottom: 5.0),
              child: Text('emailValue와\n함께 공유할프로필을 선택해주세요',
                  style: TextStyle(fontSize: 20.0, color: Colors.black54)),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: 8.0, top: 15.0, right: 8.0, bottom: 5.0),
              child: Text('상대방 프로필 선택 화면'),
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
                  //  R 요청 수락 PUT. 연동할 프로필id 선택해서 보내기
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
