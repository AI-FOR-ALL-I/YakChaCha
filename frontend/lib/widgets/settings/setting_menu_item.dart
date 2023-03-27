import 'package:flutter/material.dart';

class SettingMenuItem extends StatelessWidget {
  final IconData iconName;
  final String menuTitle;

  const SettingMenuItem({
    super.key,
    required this.iconName,
    required this.menuTitle,
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
        Container(
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
      ],
    );
  }
}
