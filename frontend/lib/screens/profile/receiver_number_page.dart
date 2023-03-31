import 'package:flutter/material.dart';
import 'dart:async';
import 'package:frontend/widgets/common/simple_app_bar.dart';

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
            padding: const EdgeInsets.only(top: 15.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6.0),
                color: const Color(0xFFE2E8E4),
              ),
              child: const Padding(
                padding: EdgeInsetsDirectional.symmetric(
                    vertical: 16.0, horizontal: 20.0),
                child: Text('번호6자리들어갈자리'),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              _showDialog();
            },
            child: Row(
              children: [
                const Text('어떻게 인증하져?'),
                Icon(Icons.help_rounded,
                    size: 20.0, color: Theme.of(context).colorScheme.onSurface),
                Text(
                  '$minutes:${seconds.toString().padLeft(2, '0')}',
                  style: const TextStyle(fontSize: 16.0),
                )
              ],
            ),
          )
        ]),
      ),
    );
  }
}
