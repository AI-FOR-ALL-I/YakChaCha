import 'package:flutter/material.dart';
import 'package:frontend/bottom_navigation.dart';
import 'package:frontend/widgets/text_search/text_search_pill_to_register.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is th root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'bottomNavigationBar Test',
      home: BottomNavigation(),
      // home: TextSearchPillToRgister()
    );
  }
}
