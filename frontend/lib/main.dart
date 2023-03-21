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
    return MaterialApp(
      theme: ThemeData(
        colorScheme: const ColorScheme(
            brightness: Brightness.light,
            primary: Color(0xFFBBE4CB),      // Main
            onPrimary: Color(0xFFFBFFFB),    // little-white
            secondary: Color(0xFF666666),    // Gray
            onSecondary: Color(0xFFE1E1E1),  // Light-Gray
            error: Color(0xFFFF6961),        // Error-Red
            onError: Color(0xFFF7CA66),      // Warning-yellow
            background: Color(0xFF4AC990),   // Success-green
            onBackground: Color(0xFF6694F7), // Info - blue
            surface: Color(0xFFBABABA),      // Placeholder
            onSurface: Color(0xFF848293)),   // Point-Purple
      ),
      title: 'bottomNavigationBar Test',
      home: const BottomNavigation(),
    );
  }
}
