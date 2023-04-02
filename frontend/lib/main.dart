import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:frontend/controller/firebase_controller.dart';
import 'package:frontend/firebase_options.dart';
import 'package:frontend/screens/login/social_login.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

// 백그라운드 + 꺼져있을때 푸시알림 처리하는 함수에 들어갈 값
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  RemoteNotification? notification = message.notification;
  if (notification != null) {
    print('noti-title : ${notification?.title}, body:${notification?.body}');
  }
  Map<String, dynamic> data = message.data;
  print(data);
  // 여기서 data값을 가지고 분기처리
  // {senderName: 사용자, senderAccountSeq: 2, type: link} (연동 메세지)
  // {profileLinkSeq: 1, type: reminder} (알람 메세지)
}

Future<void> main() async {
  KakaoSdk.init(nativeAppKey: "c940f1badb47a0c2cb210d71a84009fb");
  Get.put(FirebaseController());
  final firebaseController = Get.find<FirebaseController>();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // 얘가 백그라운드 + 꺼져있을때 푸시알림 처리
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // 얘가 켜져있을 때 푸시알림 처리
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    if (notification != null) {
      print('noti-title : ${notification.title}, body:${notification.body}');
    }
    Map<String, dynamic> data = message.data;
    // 포그라운드 상황에서는 위에 뱃지알림이 안뜨기 때문에 dialog나 다를 위젯을 띄우는 방식 고려
    // 여기서 data값을 가지고 분기처리
    // {senderName: 사용자, senderAccountSeq: 2, type: link} (연동 메세지)
    // {profileLinkSeq: 1, type: reminder} (알람 메세지)
    print(data);
  });

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
