import 'package:flutter/material.dart';
import 'package:frontend/controller/auth_controller.dart';
import 'package:frontend/controller/firebase_controller.dart';
import 'package:frontend/controller/profile_controller.dart';
import 'package:frontend/screens/login/social_login.dart';
import 'package:frontend/screens/profile/receiver_profile_page.dart';
import 'package:frontend/services/api_client.dart';
import 'package:frontend/widgets/common/simple_app_bar.dart';
import 'package:frontend/widgets/settings/setting_menu_item.dart';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  void logout(BuildContext context) async {
    final authController = Get.find<AuthController>();
    final firebaseController = Get.find<FirebaseController>();
    final profileController = Get.find<ProfileController>();

    try {
      dio.Response response = await ApiClient.logout();
      if (response.statusCode == 200) {
        // 로그아웃 성공
        authController.clearTokens();
        //firebaseController.clearTokens();
        profileController.clearProfile();
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const SocialLogin()));
      }
    } catch (error) {
      print('사용자 정보 요청 실패 $error');
    }
  }

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
          TextButton(
              onPressed: () {},
              child: const Text(
                '사용자 설정',
                style: TextStyle(color: Colors.black54),
              )),
          const SettingMenuItem(
            iconName: Icons.person,
            menuTitle: '프로필 편집',
            cases: 0,
          ),
          const SettingMenuItem(
            iconName: Icons.notifications_active_rounded,
            menuTitle: '알림설정',
            cases: 1,
          ),
          const SettingMenuItem(
            iconName: Icons.autorenew_rounded,
            menuTitle: '연동정보조회',
            cases: 2,
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 15.0, right: 15.0, top: 8.0, bottom: 8.0),
            child: Row(
              children: [
                TextButton(
                    onPressed: () {
                      logout(context);
                    },
                    child: const Text(
                      '로그아웃',
                      style: TextStyle(color: Colors.black54),
                    )),
                TextButton(
                    onPressed: () {},
                    child: const Text(
                      '탈퇴하기',
                      style: TextStyle(color: Colors.black54),
                    )),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const ReceiverProfilePage()));
                    },
                    child: const Text(
                      '상대방 연동 화면으로 임시이동',
                      style: TextStyle(color: Colors.black54),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
