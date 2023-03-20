import 'package:flutter/material.dart';
import 'package:frontend/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is th root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'bottomNavigationBar Test',
      home: Home(),
    );
  }
}