import 'package:flutter/material.dart';
import 'package:frontend/screens/profile/connected_profile_page.dart';

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

  @override
  Widget build(BuildContext context) {
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
            if (cases == 2) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ConnectedProfilePage()));
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
