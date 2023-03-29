import 'package:flutter/material.dart';

class TextFieldComponent extends StatelessWidget {
  final String hintText;
  final Function(String?) onChanged;

  const TextFieldComponent(
      {super.key, required this.hintText, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // TextField 영역이 아닌 다른 영역을 탭했을 때 키보드를 닫는 코드 작성
        FocusScope.of(context).unfocus(); // 키보드 닫기
      },
      child: TextField(
        decoration: InputDecoration(
          hintText: hintText,
          border: const OutlineInputBorder(),
        ),
        onChanged: onChanged,
      ),
    );
  }
}
