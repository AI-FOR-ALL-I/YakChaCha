import 'package:flutter/material.dart';
import 'package:frontend/screens/profile/select_profile_image_page.dart';
import 'package:frontend/widgets/common/button.dart';
import 'package:frontend/widgets/common/simple_app_bar.dart';
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
        appBar: const SimpleAppBar(title: '프로필 생성하기'),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 30,
                ),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  GestureDetector(
                      onTap: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const SelectProfileImagePage()),
                        );
                      },
                      child: Image.asset('assets/images/sampletips.jpg',
                          width: 100.0, height: 100.0)),
                ]),
                const SizedBox(
                  height: 10,
                ),
                const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    '이름',
                  ),
                ),
                TextFieldComponent(hintText: '이름', onChanged: _updateEmail),
                const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    '닉네임',
                  ),
                ),
                TextFieldComponent(hintText: '닉네임', onChanged: _updatePassword),
                const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    '성별',
                  ),
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Button(
                        text: '남성',
                        bgColor: Color(0xFFBBE4CB),
                        textColor: Color(0xFF666666)),
                    Button(
                        text: '여성',
                        bgColor: Color(0xFFBBE4CB),
                        textColor: Color(0xFF666666)),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    '임신 중이신가요?',
                  ),
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Button(
                        text: '네',
                        bgColor: Color(0xFFBBE4CB),
                        textColor: Color(0xFF666666)),
                    Button(
                        text: '아니오',
                        bgColor: Color(0xFFBBE4CB),
                        textColor: Color(0xFF666666)),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    '생년월일 입력',
                  ),
                ),
              ],
            )));
  }
}
