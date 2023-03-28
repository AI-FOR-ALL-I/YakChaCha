import 'package:flutter/material.dart';
import 'package:frontend/screens/profile/select_profile_image_page.dart';
import 'package:frontend/widgets/common/simple_app_bar.dart';
import 'package:frontend/widgets/common/text_field.dart';

class CreateProfilePage extends StatefulWidget {
  const CreateProfilePage({super.key});

  @override
  _CreateProfilePage createState() => _CreateProfilePage();
}

class _CreateProfilePage extends State<CreateProfilePage> {
  // 프로필 생성 시 전달될 변수.
  String name = '';
  String gender = 'M'; // M or F
  bool isMale = true; // 초기값은 남성
  bool isFemale = false;
  bool isPregnant = false;
  late DateTime selectedDate;

  void updateName(String? newName) {
    setState(() {
      name = newName ?? '';
    });
  }

  // will be deprecated..soon!
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
        body: SingleChildScrollView(
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    buildGenderButton('남성', isMale),
                    buildGenderButton('여성', isFemale),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    '임신 중이신가요?',
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    buildPregnancyButton('예', isPregnant),
                    buildPregnancyButton('아니오', !isPregnant),
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

  Widget buildGenderButton(String text, bool isSelected) {
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            print('isSelected $isSelected / $isMale / isFemale$isFemale');
            if (text == '남성') {
              isMale = true;
              isFemale = false;
            } else {
              isMale = false;
              isFemale = true;
            }
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: isSelected ? Colors.lightGreen : Colors.white,
              width: 2,
            ),
            color: isSelected ? Colors.white : Colors.lightGreen,
          ),
          child: Text(
            text,
            style: TextStyle(
              color: isSelected ? Colors.lightGreen : Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildPregnancyButton(String text, bool isSelected) {
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            isPregnant = text == '예' ? true : false;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: isSelected ? Colors.lightGreen : Colors.white,
              width: 2,
            ),
            color: isSelected ? Colors.white : Colors.lightGreen,
          ),
          child: Text(
            text,
            style: TextStyle(
              color: isSelected ? Colors.lightGreen : Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
