import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:frontend/controller/firebase_controller.dart';
import 'package:frontend/firebase_options.dart';
import 'package:frontend/screens/login/social_login.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin notiPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> cancelNotification() async {
  await notiPlugin.cancelAll();
}

Future<void> requestPermissions() async {
  await notiPlugin
      .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
      ?.requestPermissions(alert: true, badge: true, sound: true);
}

Future<void> showNotification({
  required title,
  required message,
}) async {
  notiPlugin.show(
      11,
      title,
      message,
      NotificationDetails(
          android: AndroidNotificationDetails(
              "channelId", "channelName", "channelDescription",
              icon: "@mipmap/ic_launcher"),
          iOS: const IOSNotificationDetails(
              badgeNumber: 1,
              subtitle: "the subtitle",
              sound: "slow_spring_board.aiff")));
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  RemoteNotification? notification = message.notification;
  print('noti-title : ${notification?.title}, body:${notification?.body}');
  Map<String, dynamic> data = message.data;
  await cancelNotification();
  await requestPermissions();
  await showNotification(title: data["title"], message: data["value"]);
}

Future<void> main() async {
  KakaoSdk.init(nativeAppKey: "c940f1badb47a0c2cb210d71a84009fb");
  Get.put(FirebaseController());
  final firebaseController = Get.find<FirebaseController>();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  var token = await FirebaseMessaging.instance.getToken().then((String? token) {
    if (token != null) {
      print('FCM Token: $token');
      firebaseController.saveTokens(token);
      return token;
    } else {
      print('Failed to get FCM Token');
    }
  });

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
      initialBinding: BindingsBuilder(() {
        Get.put(FirebaseController());
      }),
      title: 'bottomNavigationBar Test',
      home: const SocialLogin(),
    );
  }
}
