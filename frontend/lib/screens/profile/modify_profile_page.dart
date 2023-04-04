import 'package:flutter/material.dart';
import 'package:frontend/screens/profile/select_profile_image_page.dart';
import 'package:frontend/screens/profile/select_profile_page.dart';
import 'package:frontend/services/api_profiles.dart';
import 'package:frontend/widgets/common/simple_app_bar.dart';
import 'package:frontend/widgets/common/text_field.dart';
import 'package:frontend/widgets/profile/birth_date_widget.dart';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:frontend/controller/profile_controller.dart';

class ModifyProfilePage extends StatefulWidget {
  const ModifyProfilePage({super.key});

  @override
  _ModifyProfilePage createState() => _ModifyProfilePage();
}

class _ModifyProfilePage extends State<ModifyProfilePage> {
  Map<String, dynamic> profileInfo = {};
  @override
  void initState() {
    super.initState();
    getSelectedProfileInfo();
    // 프로필 정보 전달받기
  }

  // 프로필 정보 받기
  void getSelectedProfileInfo() async {
    final profileController = Get.find<ProfileController>();
    final profileLinkSeq = profileController.profileLinkSeq;
    try {
      dio.Response response = await ApiProfiles.getProfileInfo(profileLinkSeq);
      if (response.statusCode == 200) {
        final Map<String, dynamic> newData =
            Map<String, dynamic>.from(response.data['data']);
        setState(() {
          profileInfo = newData;
          name = profileInfo['name'];
          nickname = profileInfo['nickname'];
          gender = profileInfo['gender'];
          initBirthDate = profileInfo['birthDate'];
          isPregnant = profileInfo['pregnancy'];
          imgCode = profileInfo['imgCode'];
          print('$name+$nickname+$gender+$initBirthDate+$isPregnant+$imgCode');
          if (gender == 'M') {
            isMale = true;
            isFemale = false;
          } else {
            isMale = false;
            isFemale = true;
          }
        });
      } else {
        // 오류처리
      }
    } catch (e) {
      e.printError(info: 'errors');
    }
  }

  // 프로필 생성 시 전달될 변수.
  String name = '';
  String nickname = '';
  String gender = 'M'; // M or F
  bool isMale = false; // 초기값은 남성
  bool isFemale = false;
  bool isPregnant = false;
  String initBirthDate = '';
  int imgCode = 1;

  void changeProfileImage(int index) {
    setState(() {
      imgCode = index; // 선택한 이미지로 변경.
    });
  }

  void onBirthDateSelected(String birthDate) {
    // 생년월일 값 처리
    print('Selected birth date: $birthDate');
    initBirthDate = birthDate;
  }

  void updateName(String? newName) {
    setState(() {
      name = newName ?? '';
    });
  }

  void updateNickname(String? newNick) {
    setState(() {
      nickname = newNick ?? '';
    });
  }

  void sendDataToServer(BuildContext context) async {
    try {
      if (!isMale) {
        gender = 'F';
      } else {
        gender = 'M';
      }
      final profileController = Get.find<ProfileController>();
      final profileLinkSeq = profileController.profileLinkSeq;
      dio.Response response = await ApiProfiles.modifyProfile(profileLinkSeq,
          name, gender, isPregnant, initBirthDate, nickname, imgCode);
      // 이미지 코드는 지금 임의로 1로 보내는중입니다.
      // TODO: - 이미지 코드 설정

      if (response.statusCode == 200) {
        // 프로필아이디값 설정
        // final profileController = Get.find<ProfileController>();
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const SelectProfilePage()));
      }
    } catch (error) {
      print('사용자 정보 요청 실패 $error');
    }
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
                      child: Image.asset('assets/images/profile$imgCode.png',
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
                TextFieldComponent(hintText: name, onChanged: updateName),
                const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    '닉네임',
                  ),
                ),
                TextFieldComponent(
                    hintText: nickname, onChanged: updateNickname),
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
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child:
                      BirthDateWidget(onBirthDateSelected: onBirthDateSelected),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    enrollButton(context),
                  ],
                )
              ],
            )));
  }

  Widget buildGenderButton(String text, bool isSelected) {
    //bool isSelected = gender;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () {
            setState(() {
              //gender = true;
              if (text == '남성') {
                isMale = true;
                isFemale = false;
              } else {
                isMale = false;
                isFemale = true;
              }
              print('$isMale / isFemale$isFemale');
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: isSelected ? Colors.white : Colors.lightGreen,
                width: 2,
              ),
              color: isSelected ? Colors.lightGreen : Colors.white,
            ),
            child: Text(
              text,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.lightGreen,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildPregnancyButton(String text, bool isSelected) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () {
            setState(() {
              isPregnant = text == '예' ? true : false;
            });
            print('isPregnant$isPregnant');
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: isSelected ? Colors.white : Colors.lightGreen,
                width: 2,
              ),
              color: isSelected ? Colors.lightGreen : Colors.white,
            ),
            child: Text(
              text,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.lightGreen,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget enrollButton(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () {
            // 서버통신진행
            sendDataToServer(context);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: Colors.lightGreen,
                width: 2,
              ),
              color: Colors.lightGreen,
            ),
            child: const Text(
              '등록하기',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
