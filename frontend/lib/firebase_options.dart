// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCRQmGTHSBNSMpGGKp-1TkiZNiLQVS_CMo',
    appId: '1:33028661287:web:820270821a23b0e8bdee02',
    messagingSenderId: '33028661287',
    projectId: 'yakchacha',
    authDomain: 'yakchacha.firebaseapp.com',
    storageBucket: 'yakchacha.appspot.com',
    measurementId: 'G-1TK6JKRRHJ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDqw9b73DTADxj-DmHZT3qOjCMQVgbkifw',
    appId: '1:33028661287:android:7719c5cbeed06b96bdee02',
    messagingSenderId: '33028661287',
    projectId: 'yakchacha',
    storageBucket: 'yakchacha.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAxT9PaCWNtcUWyXpaYqoJpFySks_O4GLE',
    appId: '1:33028661287:ios:998db5177b59bb4abdee02',
    messagingSenderId: '33028661287',
    projectId: 'yakchacha',
    storageBucket: 'yakchacha.appspot.com',
    iosClientId: '33028661287-mpquca75fhrvnm5agcu2qn2085dq912k.apps.googleusercontent.com',
    iosBundleId: 'com.example.frontend',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAxT9PaCWNtcUWyXpaYqoJpFySks_O4GLE',
    appId: '1:33028661287:ios:998db5177b59bb4abdee02',
    messagingSenderId: '33028661287',
    projectId: 'yakchacha',
    storageBucket: 'yakchacha.appspot.com',
    iosClientId: '33028661287-mpquca75fhrvnm5agcu2qn2085dq912k.apps.googleusercontent.com',
    iosBundleId: 'com.example.frontend',
  );
}