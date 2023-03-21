import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/screens/map_page.dart';
import 'package:frontend/screens/home_page.dart';
import 'package:frontend/screens/drug_history_page.dart';
import 'package:frontend/screens/alarm_page.dart';
import 'package:frontend/screens/register_page.dart';
import 'package:frontend/screens/search/text_search_page.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({Key? key}) : super(key: key);

  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _selectedIndex = 0;

  static List<Widget> pages = <Widget>[
    const HomePage(),
    const AlarmPage(),
    const RegisterPage(),
    const DrugHistoryPage(),
    const MapPage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            leading: Center(
              child: Text('YakChaCha',
                  style: (TextStyle(
                    color: Theme.of(context).colorScheme.background,
                    overflow: TextOverflow.visible,
                  )),
                  softWrap: false,
                  maxLines: 1),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.search_outlined),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TextSearchPage()));
                },
              ),
              IconButton(
                icon: Icon(Icons.notifications_outlined),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.person_outlined),
                onPressed: () {},
              ),
            ],
            backgroundColor: Colors.white,
            iconTheme:
                IconThemeData(color: Theme.of(context).colorScheme.secondary)),
        body: pages[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: Colors.grey,
          // ignore: prefer_const_literals_to_create_immutables
          items: [
            const BottomNavigationBarItem(
                icon: Icon(Icons.card_giftcard), label: 'home'),
            const BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.gift), label: 'alarm'),
            const BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.add_circled), label: 'register'),
            const BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.alarm), label: 'mydrugs'),
            const BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.map_pin_ellipse), label: 'pharmacy'),
          ],
        ));
  }
}
