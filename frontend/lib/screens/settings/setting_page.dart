import 'package:flutter/material.dart';
import 'package:frontend/controller/auth_controller.dart';
import 'package:frontend/controller/firebase_controller.dart';
import 'package:frontend/controller/profile_controller.dart';
import 'package:frontend/screens/login/social_login.dart';
import 'package:frontend/services/api_client.dart';
import 'package:frontend/services/api_profiles.dart';
import 'package:frontend/widgets/common/simple_app_bar.dart';
import 'package:frontend/widgets/settings/setting_menu_item.dart';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:frontend/controller/multiprofile_controller.dart';
import 'package:frontend/bottom_navigation.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  Map<String, dynamic> info = {};
  // 자동로그인하면 multiprofilecontroller 내용이 다 사라짐
  // 어쩔수없이 profilelist 다 받아오는 api 호출
  List<Map<String, dynamic>> multiData = [];
  // api 선언부
  void getMultiProfiles() async {
    try {
      dio.Response response = await ApiProfiles.getMultiProfiles();
      if (response.statusCode == 200) {
        final List<Map<String, dynamic>> newData =
            List<Map<String, dynamic>>.from(response.data['data']);
        setState(() {
          multiData = newData;
        });
      } else {
        // error handling
      }
    } catch (e) {
      // error handling
    }
  }

  bool isOwner = false;
  void logout(BuildContext context) async {
    final authController = Get.find<AuthController>();
    final firebaseController = Get.find<FirebaseController>();
    final profileController = Get.find<ProfileController>();

    try {
      dio.Response response = await ApiClient.logout();
      if (response.statusCode == 200) {
        // 로그아웃 성공
        await authController.clearTokens();
        //firebaseController.clearTokens();
        await profileController.clearProfile();
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const SocialLogin()));
        print('로그아웃 직후 프로파일 번호${profileController.profileLinkSeq ?? 'null'}');
      }
    } catch (error) {
      print('사용자 정보 요청 실패 $error');
    }
  }

  void withDraw(BuildContext context) async {
    final authController = Get.find<AuthController>();
    final firebaseController = Get.find<FirebaseController>();
    final profileController = Get.find<ProfileController>();
    try {
      dio.Response response = await ApiClient.withDraw();
      if (response.statusCode == 200) {
        // 로그아웃 성공
        //   authController.clearTokens();
        //   //firebaseController.clearTokens();
        //   profileController.clearProfile();
        //   Navigator.push(context,
        //       MaterialPageRoute(builder: (context) => const SocialLogin()));
        // 모든 컨트롤러 상태 재설정
        Get.reset();

        // 초기 화면으로 이동
        Get.offAll(const SocialLogin());
      }
    } catch (error) {
      print('사용자 정보 요청 실패 $error');
    }
  }

  void profileDetails() async {
    final profileController = Get.find<ProfileController>();
    try {
      dio.Response response =
          await ApiProfiles.getProfileInfo(profileController.profileLinkSeq);
      if (response.statusCode == 200) {
        //dio.interceptors.add(CurlLoggerDioInterceptor(printOnSuccess: true));
        final Map<String, dynamic> temp =
            Map<String, dynamic>.from(response.data['data']);
        setState(() {
          isOwner = temp['owner'];
        });
        print('isOwner$isOwner');
      }
    } catch (e) {
      print('error$e');
    }
  }

  MultiProfileController multiProfileController =
      Get.put(MultiProfileController());

  @override
  void initState() {
    super.initState();
    getMultiProfiles();
    profileDetails();
    // 여기서 프로필 정보 다 가져오기
  }

  @override
  Widget build(BuildContext context) {
    ProfileController profileController = Get.find<ProfileController>();
    //ProfileController profileController = Get.find(tag: 'profileController');
    return Scaffold(
      appBar: const SimpleAppBar(title: '사용자 전환'),
      body: Column(
        children: [
          SizedBox(
            height: 170,
            // 여기가 프로필 위젯들
            child: Obx(() => ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: multiData.length,
                itemBuilder: (BuildContext context, int index) {
                  // var profile = multiProfileController.multiProfileList[index];
                  // 변경
                  var profile = multiData[index];
                  // 변경
                  return Padding(
                    padding: const EdgeInsets.only(
                        left: 10.0, top: 15.0, right: 5.0, bottom: 15.0),
                    child: GestureDetector(
                      onTap: () {
                        //print(multiProfileController.multiProfileList[index]);
                        print(multiData[index]);
                        if (profile["profileLinkSeq"] !=
                            profileController.profileLinkSeq) {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Dialog(
                                  child: SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.2,
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                              '${profile["nickname"]} 님의 프로필로 전환하시겠어요?'),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              TextButton(
                                                  onPressed: () async {
                                                    await profileController
                                                        .saveProfile(profile[
                                                            "profileLinkSeq"]);
                                                    Navigator.pop(context);
                                                    Navigator.pop(context);

                                                    Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const BottomNavigation(
                                                                  where: 0)),
                                                    );
                                                  },
                                                  child: const Text('예')),
                                              TextButton(
                                                  onPressed: () {},
                                                  child: const Text('아니오'))
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              });
                        }
                      },
                      // {profileLinkSeq: 20, imgCode: 1, nickname: 깃기, name: 깃기, gender: M, birthDate: 2011-04-05, owner: true, pregnancy: false}
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: profile["profileLinkSeq"] ==
                                      profileController.profileLinkSeq
                                  ? Border.all(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .background, // 테두리 색상을 선택하세요.
                                      width: 3, // 테두리 두께를 조절하세요.
                                    )
                                  : null,
                              borderRadius: BorderRadius.circular(13.0),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Image.asset(
                                  'assets/images/profile${profile["imgCode"]}.png',
                                  width: profile["profileLinkSeq"] ==
                                          profileController.profileLinkSeq
                                      ? 114
                                      : 120,
                                  height: profile["profileLinkSeq"] ==
                                          profileController.profileLinkSeq
                                      ? 114
                                      : 120,
                                  fit: BoxFit.cover),
                            ),
                          ),
                          Text('${profile["nickname"]}')
                        ],
                      ),
                    ),
                  );
                })),
          ),
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
          if (isOwner)
            const SettingMenuItem(
              iconName: Icons.autorenew_rounded,
              menuTitle: '연동정보조회',
              cases: 2,
            ),
          if (!isOwner)
            const SizedBox(
              height: 15,
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
                    onPressed: () {
                      withDraw(context);
                    },
                    child: const Text(
                      '탈퇴하기',
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
