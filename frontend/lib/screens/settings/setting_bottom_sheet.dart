import 'package:flutter/material.dart';
import 'package:frontend/widgets/settings/bottom_sheet_item.dart';

class SettingBottomSheet extends StatelessWidget {
  const SettingBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.25, // 화면 높이의 1/4 크기
      child: const Column(
        children: [
          // 모달 화면 내용 구현
          BottomSheetItem(
              iconName: Icons.person, menuTitle: '프로필 추가하기', cases: 0),
          BottomSheetItem(
              iconName: Icons.autorenew_rounded,
              menuTitle: '타 회원 프로필 추가하기',
              cases: 1),
        ],
      ),
    );
  }
}
