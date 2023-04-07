import 'package:flutter/material.dart';
import 'package:frontend/controller/profile_controller.dart';
import 'package:frontend/screens/profile/connected_profile_page.dart';
import 'package:frontend/screens/profile/modify_profile_page.dart';
import 'package:app_settings/app_settings.dart';
import 'package:get/get.dart';

class SettingMenuItem extends StatelessWidget {
  final IconData iconName;
  final String menuTitle;
  final int cases;

  const SettingMenuItem({
    super.key,
    required this.iconName,
    required this.menuTitle,
    required this.cases,
  });

  // getPermission() async {
  //   var status = await Permission.notification.status;
  //   if (status.isGranted) {
  //     print('허락됨');
  //   } else if (status.isDenied) {
  //     print('거절됨');
  //     Permission.notification.request();
  //   }
  //   if (status.isPermanentlyDenied) {
  //     openAppSettings();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final profileController = Get.find<ProfileController>();
    final int profileLinkSeq = profileController.profileLinkSeq;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
              left: 15.0, right: 15.0, top: 5.0, bottom: 5.0),
          child: Divider(
            color: Colors.grey[400],
            thickness: 1,
          ),
        ),
        GestureDetector(
          onTap: () {
            if (cases == 0) {
              // TODO: 프로필 수정 페이지로 이동
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ModifyProfilePage()));
            }
            if (cases == 1) {
              // 여기다 설정
              AppSettings.openAppSettings();
            }
            if (cases == 2) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ConnectedProfilePage(
                          profileLinkSeq: profileLinkSeq)));
            }
            // FIXME: 사용자 설정 눌렀을 때 .프로필 편집 화면 다시 만들어야할듯.
            // if (cases == 0) {
            //   Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //           builder: (context) => const SelectProfilePage()));
            // }
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
            ),
            padding: const EdgeInsets.only(
                top: 8.0, left: 15.0, right: 15.0, bottom: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(iconName, color: const Color(0xFFBBE4CB)),
                const SizedBox(
                  width: 15.0,
                ),
                Text(menuTitle,
                    style: const TextStyle(
                        color: Color(0xFF666666),
                        fontSize: 16,
                        fontWeight: FontWeight.w600))
              ],
            ),
          ),
        ),
      ],
    );
  }
}
