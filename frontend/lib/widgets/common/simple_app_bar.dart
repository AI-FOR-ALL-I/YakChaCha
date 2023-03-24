import 'package:flutter/material.dart';
import 'package:frontend/screens/alarm_page.dart';

class SimpleAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const SimpleAppBar({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(Icons.arrow_back_ios_outlined, color: Colors.black),
      ),
      title: Text(title, style: TextStyle(color: Colors.black)),
      centerTitle: true,
      actions: [
        if (title == '알람 수정')
          TextButton(
              onPressed: () {
                // TODO: 만약에 알람을 삭제하고 알람 메인 페이지로 이동하면, 뒤로가기 눌렀을 때 어떻게 되는 거지..?
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AlarmPage()));
              },
              child: Text(
                '삭제',
                style: TextStyle(
                  color: Colors.red,
                ),
              ))
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
