import 'package:flutter/material.dart';
import 'dart:async';
import 'package:frontend/widgets/common/simple_app_bar.dart';
import 'package:frontend/bottom_navigation.dart';

class ReceiverNumberPage extends StatefulWidget {
  const ReceiverNumberPage({super.key});

  @override
  State<ReceiverNumberPage> createState() => _ReceiverNumberPageState();
}

class _ReceiverNumberPageState extends State<ReceiverNumberPage> {
  int remainingTime = 180;
  late Timer timer;
  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('안내'),
          content: const Text('메시지박스창에 들어갈 내용을 여기에 작성하세요.'),
          actions: <Widget>[
            TextButton(
              child: const Text('닫기'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (remainingTime > 0) {
          remainingTime--;
        } else {
          timer.cancel();
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const BottomNavigation(
                        where: 0,
                      )));
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final minutes = (remainingTime / 60).floor();
    final seconds = (remainingTime % 60);
    return Scaffold(
      appBar: const SimpleAppBar(title: '번호 확인'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('상대방의 기기에\n인증번호를 등록해주세요.',
              style: TextStyle(fontSize: 20.0, color: Colors.black54)),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Container(
              width: 320.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6.0),
                color: const Color(0xFFE2E8E4),
              ),
              child: const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  '번호6자리들어갈자리',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 8.0,
          ),
          GestureDetector(
            onTap: () {
              _showDialog();
            },
            child: Row(
              children: [
                const Text('어떻게 인증하져?'),
                const SizedBox(
                  width: 5.0,
                ),
                Icon(Icons.help_rounded,
                    size: 20.0, color: Theme.of(context).colorScheme.onSurface),
                const SizedBox(
                  width: 5.0,
                ),
                Text(
                  '$minutes:${seconds.toString().padLeft(2, '0')}',
                  style: const TextStyle(fontSize: 16.0),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 4.0,
          ),
          const Text('3분안에 인증 실패 시 처음부터 인증을 진행해야합니다.',
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 15.0, color: Colors.red)),
        ]),
      ),
    );
  }
}
