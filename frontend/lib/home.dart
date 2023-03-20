import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/screens/fifth_page.dart';
import 'package:frontend/screens/first_page.dart';
import 'package:frontend/screens/fourth_page.dart';
import 'package:frontend/screens/second_page.dart';
import 'package:frontend/screens/third_page.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  static List<Widget> pages = <Widget>[
    const FirstPage(),
    const SecondPage(),
    const ThirdPage(),
    const FourthPage(),
    const FifthPage()
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
          title: const Text('bottomNavigationBar Test'),
        ),
        body: pages[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: Colors.grey,
          // ignore: prefer_const_literals_to_create_immutables
          items: [
            const BottomNavigationBarItem(
                icon: Icon(Icons.card_giftcard), label: 'Tab1'),
            const BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.gift), label: 'Tab2'),
            const BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.add_circled), label: 'Tab3'),
            const BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.alarm), label: 'Tab4'),
            const BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.map_pin_ellipse), label: 'Tab5'),
          ],
        ));
  }
}
