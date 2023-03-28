import 'package:flutter/material.dart';
import 'package:frontend/bottom_navigation.dart';
import 'package:frontend/controller/auth_controller.dart';
import 'package:frontend/controller/firebase_controller.dart';
import 'package:frontend/screens/profile/create_profile_page.dart';
import 'package:frontend/services/api_client.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';

class SocialLogin extends StatelessWidget {
  const SocialLogin({Key? key}) : super(key: key);

  void getUserInfo(BuildContext context) async {
    //Get.put(FirebaseController());
    //Get.put(AuthController());
    final firebaseController = Get.find<FirebaseController>();
    final authController = Get.find<AuthController>();
    final firebaseToken = firebaseController.firebaseToken;
    try {
      User user = await UserApi.instance.me();
      dio.Response response = await ApiClient.login(
          'KAKAO', user.kakaoAccount?.email, user.id.toString(), firebaseToken);
      if (response.statusCode == 200) {
        // 요청 성공!
        Map<String, dynamic> responseData = response.data;
        String accessToken = responseData['data']['accessToken'];
        String refreshToken = responseData['data']['refreshToken'];
        authController.saveTokens(accessToken, refreshToken);
        if (responseData['data']['profile'] == true) {
          // navigate to ProfileSelectPage
        } else {
          // navigate to CreateProfilePage
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const CreateProfilePage()));
        }
      }
      // print('Response check $response');
    } catch (error) {
      print('사용자 정보 요청 실패 $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: GestureDetector(
                  onTap: () async {
                    // do something on
                    // MARK: - 임시로 홈화면으로 이동해주는 버튼으로 설정
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const BottomNavigation()),
                    );
                  },
                  child: Image.asset(
                    'assets/images/sampletips.jpg',
                    width: 100.0,
                    height: 100.0,
                  )),
            ),
            GestureDetector(
                onTap: () async {
                  // do something on
                  if (await isKakaoTalkInstalled()) {
                    try {
                      await UserApi.instance.loginWithKakaoTalk();
                      print('설치된 카카오톡으로 로그인 성공');
                      getUserInfo(context);
                    } catch (error) {
                      print('설치된 카카오톡으로 로그인 실패 $error');
                      // 카카오톡에 연결된 카카오계정이 없는 경우, 카카오계정으로 로그인
                      try {
                        OAuthToken token =
                            await UserApi.instance.loginWithKakaoAccount();
                        //print('카카오계정으로 로그인 성공');
                        print('웹에서 카카오계정으로 로그인 성공 ${token.accessToken}');
                        getUserInfo(context);
                      } catch (error) {
                        print('웹에서 카카오계정으로 로그인 실패 $error');
                      }
                    }
                  } else {
                    try {
                      await UserApi.instance.loginWithKakaoAccount();
                      print('카카오계정으로 로그인 성공');
                      getUserInfo(context);
                    } catch (error) {
                      print('카카오계정으로 로그인 실패 $error');
                    }
                  }
                },
                child: Image.asset('assets/images/kakao_login_large.png')),
            //TextButton(child: const Text("카카오 로그인"), onPressed: () async {})
          ],
        ),
      ),
    );
  }
}
