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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyB0QH0vFjUdFfD6wyaSoiRqhc5a6Ldlq8g',
    appId: '1:185541542489:web:cf7594580220eb7f9f6748',
    messagingSenderId: '185541542489',
    projectId: 'checkapp-asiendosoftware',
    authDomain: 'checkapp-asiendosoftware.firebaseapp.com',
    storageBucket: 'checkapp-asiendosoftware.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC6efcWeVOqlW7_2rAA7zOGFxn_4LFm160',
    appId: '1:185541542489:android:975f52127db85ec89f6748',
    messagingSenderId: '185541542489',
    projectId: 'checkapp-asiendosoftware',
    storageBucket: 'checkapp-asiendosoftware.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC5r56Gc3bdKr5dfL6nOXPP8PDABVh4sTo',
    appId: '1:185541542489:ios:f9f645ceab6688549f6748',
    messagingSenderId: '185541542489',
    projectId: 'checkapp-asiendosoftware',
    storageBucket: 'checkapp-asiendosoftware.appspot.com',
    iosClientId: '185541542489-ddemk9fiksttc9407t5hlnei08i2g25j.apps.googleusercontent.com',
    iosBundleId: 'com.example.checkapp',
  );
}
