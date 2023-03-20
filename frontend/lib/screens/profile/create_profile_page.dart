import 'package:flutter/material.dart';
import 'package:frontend/widgets/common/text_field.dart';

class CreateProfilePage extends StatefulWidget {
  const CreateProfilePage({super.key});

  @override
  _CreateProfilePage createState() => _CreateProfilePage();
}

class _CreateProfilePage extends State<CreateProfilePage> {
  String _email = '';
  String _password = '';

  void _updateEmail(String? newEmail) {
    setState(() {
      _email = newEmail ?? '';
    });
  }

  void _updatePassword(String? newPassword) {
    setState(() {
      _password = newPassword ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    // Build the UI here
    return Scaffold(
        appBar: AppBar(
          title: const Text('회원가입'),
        ),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 30,
                ),
                const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('이미지 선택화면 들어갈자리'),
                    ]),
                const SizedBox(
                  height: 10,
                ),
                const Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Text(
                    '이름',
                  ),
                ),
                TextFieldComponent(hintText: '이름', onChanged: _updateEmail),
                const Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Text(
                    '닉네임',
                  ),
                ),
                TextFieldComponent(hintText: '닉네임', onChanged: _updatePassword),
                const Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Text(
                    '성별',
                  ),
                ),
              ],
            )));
  }
}
