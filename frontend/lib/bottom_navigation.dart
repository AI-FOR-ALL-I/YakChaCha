import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/screens/map_page.dart';
import 'package:frontend/screens/home_page.dart';
import 'package:frontend/screens/drug_history_page.dart';
import 'package:frontend/screens/alarm_page.dart';
import 'package:frontend/screens/register_page.dart';
import 'package:frontend/widgets/common/custom_main_app_bar.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({Key? key}) : super(key: key);

  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _selectedIndex = 0;

  static List<Widget> pages = <Widget>[
    HomePage(),
    const AlarmPage(),
    const RegisterPage(),
    const DrugHistoryPage(),
    const MapPage()
  ];

  void _onItemTapped(int index) {
    if (index == 2) {
      // 알약 등록용 다이얼로그
      showDialog(
          context: context,
          builder: (BuildContext constext) {
            return Dialog(
                child: SizedBox(
              height: 200.0,
              width: MediaQuery.of(context).size.width * 0.8,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        showDialog(
                            context: context,
                            builder: (BuildContext constext) {
                              return Dialog(
                                child: SizedBox(
                                  height: 200.0,
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: const [
                                      Text('사진 촬영'),
                                      Text('앨범에서 가져오기')
                                    ],
                                  ),
                                ),
                              );
                            });
                      },
                      child: const Text('알약 사진으로 등록')),
                  const Text('처방전 사진으로 등록'),
                  GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RegisterPage()),
                        );
                      },
                      child: const Text('텍스트 검색으로 등록'))
                ],
              ),
            ));
          });
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomMainAppBar(isMain: _selectedIndex == 0 ? true : false),
        extendBodyBehindAppBar:
            _selectedIndex == 0 ? true : false, // main에서는 앱바가 바디에 올라가게끔
        body: pages[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: Colors.grey,
          // ignore: prefer_const_literals_to_create_immutables
          items: [
            const BottomNavigationBarItem(
                icon: Icon(Icons.home_filled),
                label: 'home',
                activeIcon: Icon(Icons.home_filled, color: Color(0xFFBBE4CB))),
            const BottomNavigationBarItem(
                icon: Icon(Icons.access_time),
                label: 'alarm',
                activeIcon: Icon(Icons.access_time, color: Color(0xFFBBE4CB))),
            const BottomNavigationBarItem(
                icon: Icon(Icons.add_box_outlined),
                label: 'register',
                activeIcon:
                    Icon(Icons.add_box_outlined, color: Color(0xFFBBE4CB))),
            const BottomNavigationBarItem(
                icon: Icon(MdiIcons.pill),
                label: 'mydrugs',
                activeIcon: Icon(
                  MdiIcons.pillMultiple,
                  color: Color(0xFFBBE4CB),
                )),
            const BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.map_fill),
                label: 'pharmacy',
                activeIcon: Icon(Icons.map, color: Color(0xFFBBE4CB))),
          ],
        ));
  }
}
