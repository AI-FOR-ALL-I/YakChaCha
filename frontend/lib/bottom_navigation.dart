import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/screens/map_page.dart';
import 'package:frontend/screens/home_page.dart';
import 'package:frontend/screens/drug_history_page.dart';
import 'package:frontend/screens/alarm_page.dart';
import 'package:frontend/screens/register_page.dart';
import 'package:frontend/widgets/common/custom_main_app_bar.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:geolocator/geolocator.dart';

class BottomNavigation extends StatefulWidget {
  final int where;
  const BottomNavigation({super.key, required this.where});

  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _selectedIndex = 0;
  double _latSmall = 0.0;
  double _lngBig = 0.0;

  List<Widget> pages = [];

  @override
  void initState() {
    super.initState();
    determinePosition();
    setState(() {
      _selectedIndex = widget.where;
      pages = <Widget>[
        const HomePage(),
        const AlarmPage(),
        const RegisterPage(isCameraOCR: false, isAlbumOCR: false),
        const DrugHistoryPage(),
        MapPage(latSmall: _latSmall, lngBig: _lngBig),
      ];
    });
  }

  determinePosition() async {
    final info = await Geolocator.getCurrentPosition();
    setState(() {
      _latSmall = info.latitude;
      _lngBig = info.longitude;
      pages[4] = MapPage(latSmall: _latSmall, lngBig: _lngBig);
    });
  }

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
                                    children: [
                                      GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const RegisterPage(
                                                          isCameraOCR: true,
                                                          isAlbumOCR: false,
                                                        )));
                                          },
                                          child: const Text('사진 촬영',
                                              style: TextStyle(
                                                  fontSize:
                                                      20))), // 등록화면으로 이동시키고 동시에 카메라 킨다.
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const RegisterPage(
                                                        isCameraOCR: false,
                                                        isAlbumOCR: true,
                                                      )));
                                        },
                                        child: const Text('앨범에서 가져오기',
                                            style: TextStyle(fontSize: 20)),
                                      ) // 등록화면으로 이동시키고 동시에 앨범 킨다.
                                    ],
                                  ),
                                ),
                              );
                            });
                      },
                      child: const Text('처방전 사진으로 등록',
                          style: TextStyle(fontSize: 20))),
                  GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RegisterPage(
                                    isCameraOCR: false,
                                    isAlbumOCR: false,
                                  )),
                        );
                      },
                      child: const Text('텍스트 / 알약 사진 검색으로 등록',
                          style: TextStyle(fontSize: 20)))
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
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: CustomMainAppBar(isMain: _selectedIndex == 0 ? true : false),
        extendBodyBehindAppBar:
            _selectedIndex == 0 ? true : false, // main에서는 앱바가 바디에 올라가게끔
        body: pages[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          iconSize: 27,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: Colors.grey,
          // ignore: prefer_const_literals_to_create_immutables
          items: [
            const BottomNavigationBarItem(
                icon: Icon(Icons.home_filled),
                label: 'Home',
                activeIcon: Icon(Icons.home_filled, color: Color(0xFFBBE4CB))),
            const BottomNavigationBarItem(
                icon: Icon(Icons.access_time),
                label: 'Alarm',
                activeIcon: Icon(Icons.access_time, color: Color(0xFFBBE4CB))),
            const BottomNavigationBarItem(
                icon: Icon(Icons.add_box_outlined),
                label: 'Register',
                activeIcon:
                    Icon(Icons.add_box_outlined, color: Color(0xFFBBE4CB))),
            const BottomNavigationBarItem(
                icon: Icon(MdiIcons.pill),
                label: 'MyDrugs',
                activeIcon: Icon(
                  MdiIcons.pillMultiple,
                  color: Color(0xFFBBE4CB),
                )),
            const BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.map_fill),
                label: 'Pharmacy',
                activeIcon: Icon(Icons.map, color: Color(0xFFBBE4CB))),
          ],
        ),
      ),
    );
  }
}
