import 'package:flutter/material.dart';
import 'package:frontend/controller/auth_controller.dart';
import 'package:frontend/controller/firebase_controller.dart';
import 'package:frontend/screens/profile/create_profile_page.dart';
import 'package:frontend/screens/profile/select_profile_page.dart';
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
      String? kName = user.kakaoAccount?.profile?.nickname;
      dio.Response response = await ApiClient.login('KAKAO',
          user.kakaoAccount?.email, user.id.toString(), firebaseToken, kName);
      if (response.statusCode == 200) {
        // 요청 성공!
        Map<String, dynamic> responseData = response.data;
        String accessToken = responseData['data']['accessToken'];
        String refreshToken = responseData['data']['refreshToken'];
        // print('로그인결과$accessToken // $refreshToken');
        // authController.saveTokens(accessToken, refreshToken);
        if (responseData['data']['profile'] == true) {
          authController.saveTokens(accessToken, refreshToken);
          // String savedAccessToken = authController.accessToken;
          // String savedRefreshToken = authController.refreshToken;
          // print('저장된토큰재재확인$savedAccessToken // $savedRefreshToken');
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const SelectProfilePage()));
        } else {
          authController.saveTokens(accessToken, refreshToken);
          // String savedAccessToken = authController.accessToken;
          // String savedRefreshToken = authController.refreshToken;
          // print('저장된토큰재재확인$savedAccessToken // $savedRefreshToken');
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
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Image.asset(
                    'assets/images/character.png',
                    width: 230.0,
                    height: 230.0,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
                    child: Image.asset(
                        'assets/images/kakao_login_medium_narrow.png'))
              ],
            )
            //TextButton(child: const Text("카카오 로그인"), onPressed: () async {})
          ],
        ),
      ),
    );
  }
}
