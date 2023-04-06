import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:frontend/controller/auth_controller.dart';
import 'package:frontend/controller/firebase_controller.dart';
import 'package:frontend/bottom_navigation.dart';
import 'package:frontend/controller/profile_controller.dart';
import 'package:frontend/firebase_options.dart';
import 'package:frontend/screens/login/social_login.dart';
import 'package:frontend/screens/profile/receiver_profile_page.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:geolocator/geolocator.dart';

// 백그라운드 + 꺼져있을때 푸시알림 처리하는 함수에 들어갈 값
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  RemoteNotification? notification = message.notification;
  if (notification != null) {
    // print('noti-title : ${notification?.title}, body:${notification?.body}');
    print('noti-title : ${notification.title}, body:${notification.body}');
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
  Get.put(ProfileController());
  Get.put(AuthController());
  final firebaseController = Get.find<FirebaseController>();

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // 얘가 백그라운드 + 꺼져있을때 푸시알림 처리
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // 얘가 켜져있을 때 푸시알림 처리

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

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final info = Geolocator.getCurrentPosition();
  final profileController = Get.find<ProfileController>();
  final authController = Get.find<AuthController>();
  // index
  final int _currentIndex = 0;

  // 포그라운드에서 메세지를 수신했을 때 -> modal 띄우고 이동
  void onMessageRecieved(RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    if (notification != null) {
      print('noti_title : ${notification.title}, body: ${notification.body}');
    }
    Map<String, dynamic> data = message.data;
    if (data["type"] == "link") {
      showDialog(
          context: navigatorKey.currentState!.context,
          builder: (BuildContext context) {
            return AlertDialog(
                title: Center(child: Text('${notification?.title}')),
                content: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${notification?.body}'),
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ReceiverProfilePage(
                                        senderAccountSeq: int.parse(
                                            data["senderAccountSeq"]))));
                          },
                          child: const Text("연동하러 가기"))
                    ],
                  ),
                ));
          });
      print(data);
    } else if (data["type"] == "reminder") {
      print("here");
      profileController.saveProfile(int.parse(data["profileLinkSeq"]));
      print("here2");
      showDialog(
          context: navigatorKey.currentState!.context,
          builder: (BuildContext context) {
            return AlertDialog(
                title: Center(child: Text('${notification?.title}')),
                content: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${notification?.body}'),
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const BottomNavigation(
                                          where: 0,
                                        )));
                          },
                          child: const Text("약 먹으러 가기"))
                    ],
                  ),
                ));
          });
    } else if (data["type"] == "auth") {
      showDialog(
          context: navigatorKey.currentState!.context,
          builder: (BuildContext context) {
            return AlertDialog(
                title: Center(child: Text('${notification?.title}')),
                content: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${notification?.body}'),
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const BottomNavigation(
                                          where: 0,
                                        )));
                          },
                          child: const Text("홈 화면으로 돌아가기"))
                    ],
                  ),
                ));
          });
    }
  }

  void onMessageOpen(RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    if (notification != null) {
      print('noti_title : ${notification.title}, body: ${notification.body}');
    }
    Map<String, dynamic> data = message.data;
    if (data["type"] == "link") {
      Navigator.push(
          navigatorKey.currentState!.context,
          MaterialPageRoute(
              builder: (context) => ReceiverProfilePage(
                  senderAccountSeq: int.parse(data["senderAccountSeq"]))));
    } else if (data["type"] == "reminder") {
      profileController.saveProfile(int.parse(data["profileLinkSeq"]));
      Navigator.push(
          navigatorKey.currentState!.context,
          MaterialPageRoute(
              builder: (context) => const BottomNavigation(
                    where: 0,
                  )));
    }
  }

  Future<void> checkInitialMessage() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      onMessageOpen(initialMessage);
    }
  }

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      onMessageRecieved(message);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      onMessageOpen(message);
    });
    checkInitialMessage();
    // 토큰 유효성 체크
    authController.refreshTokenIfNeeded();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorKey: navigatorKey,
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
      ), // color:Theme.of(context).colorScheme.background
      initialBinding: BindingsBuilder(() {
        Get.put(FirebaseController());
      }),
      title: 'bottomNavigationBar Test',
      initialRoute: authController.isLoggedIn ? '/' : '/login',
      getPages: [
        GetPage(name: '/', page: () => const BottomNavigation(where: 0)),
        GetPage(name: '/login', page: () => const SocialLogin()),
      ],
      // home: Obx(() {
      //   final isLoggedIn = authController.isLoggedIn;
      //   if (!isLoggedIn) {
      //     return const SocialLogin();
      //   } else {
      //     return const BottomNavigation(where: 0);
      //   }
      // })
    );
  }
}
