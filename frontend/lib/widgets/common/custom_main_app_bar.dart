import 'package:flutter/material.dart';
import 'package:frontend/screens/search/text_search_page.dart';
import 'package:frontend/screens/settings/setting_page.dart';

class CustomMainAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomMainAppBar({Key? key, required this.isMain}) : super(key: key);
  final bool isMain; // Main화면에서는 투명한 앱바에 하얀 글씨
  @override
  Widget build(BuildContext context) {
    return AppBar(
        leading: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text('YakChaCha',
                style: (TextStyle(
                  color: isMain
                      ? Colors.white
                      : Theme.of(context).colorScheme.background,
                  overflow: TextOverflow.visible,
                )),
                softWrap: false,
                maxLines: 1),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.search_outlined,
              color: isMain ? Colors.white : Colors.grey,
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const TextSearchPage(isRegister: false)));
            },
          ),
          IconButton(
            icon: Icon(Icons.notifications_outlined,
                color: isMain ? Colors.white : Colors.grey),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.person_outlined,
                color: isMain ? Colors.white : Colors.grey),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const SettingPage()));
            },
          ),
        ],
        backgroundColor: isMain ? Colors.transparent : Colors.white,
        elevation: 0.0,
        iconTheme:
            IconThemeData(color: Theme.of(context).colorScheme.secondary));
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
