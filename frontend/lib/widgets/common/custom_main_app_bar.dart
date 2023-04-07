import 'package:flutter/material.dart';
import 'package:frontend/screens/search/text_search_page.dart';
import 'package:frontend/screens/settings/setting_page.dart';

class CustomMainAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomMainAppBar({Key? key, required this.isMain}) : super(key: key);
  final bool isMain; // Main화면에서는 투명한 앱바에 하얀 글씨
  @override
  Widget build(BuildContext context) {
    return AppBar(
        leading: null,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: Image.asset(
              isMain ? 'assets/images/logo2.png' : 'assets/images/logo3.png',
              width: MediaQuery.of(context).size.width * 0.33,
              fit: BoxFit.contain),
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
          // IconButton(
          //   icon: Icon(Icons.notifications_outlined,
          //       color: isMain ? Colors.white : Colors.grey),
          //   onPressed: () {},
          // ),
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
