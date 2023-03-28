import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:frontend/bottom_navigation.dart';
import 'package:frontend/screens/login/social_login.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

void main() async {
  KakaoSdk.init(nativeAppKey: "c940f1badb47a0c2cb210d71a84009fb");
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.instance.getToken().then((String? token) {
    if (token != null) {
      print('FCM Token: $token');
    } else {
      print('Failed to get FCM Token');
    }
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is th root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        theme: ThemeData(
          colorScheme: const ColorScheme(
              brightness: Brightness.light,
              primary: Color(0xFFBBE4CB), // Main
              onPrimary: Color(0xFFFBFFFB), // little-white
              secondary: Color(0xFF666666), // Gray
              onSecondary: Color(0xFFE1E1E1), // Light-Gray
              error: Color(0xFFFF6961), // Error-Red
              onError: Color(0xFFF7CA66), // Warning-yellow
              background: Color(0xFF4AC990), // Success-green
              onBackground: Color(0xFF6694F7), // Info - blue
              surface: Color(0xFFBABABA), // Placeholder
              onSurface: Color(0xFF848293)), // Point-Purple
        ), // color:Theme.of(context).colorScheme.primary
        title: 'bottomNavigationBar Test',
        home: BottomNavigation() // const SocialLogin(),
        );
  }
}
