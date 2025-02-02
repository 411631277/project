// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return windows;
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
    apiKey: 'AIzaSyCKIiHYGOvNIV0i17SCN5Ol9mlCWd7Zzfk',
    appId: '1:210748048462:web:e703468f5639f56f2aaf1f',
    messagingSenderId: '210748048462',
    projectId: 'project-f0a4a',
    authDomain: 'project-f0a4a.firebaseapp.com',
    storageBucket: 'project-f0a4a.firebasestorage.app',
    measurementId: 'G-MDDHF3D8KQ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBPcnZR8I1bzAb_1nFQVhsMGYneTZu6BWk',
    appId: '1:210748048462:android:e300bbbfa8d7ad672aaf1f',
    messagingSenderId: '210748048462',
    projectId: 'project-f0a4a',
    storageBucket: 'project-f0a4a.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA4YdllrTVp4HRAzFH2C7j_8qlJDAusX4g',
    appId: '1:210748048462:ios:47906fc91cc331ee2aaf1f',
    messagingSenderId: '210748048462',
    projectId: 'project-f0a4a',
    storageBucket: 'project-f0a4a.firebasestorage.app',
    iosBundleId: 'com.example.doctor2',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyA4YdllrTVp4HRAzFH2C7j_8qlJDAusX4g',
    appId: '1:210748048462:ios:47906fc91cc331ee2aaf1f',
    messagingSenderId: '210748048462',
    projectId: 'project-f0a4a',
    storageBucket: 'project-f0a4a.firebasestorage.app',
    iosBundleId: 'com.example.doctor2',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCKIiHYGOvNIV0i17SCN5Ol9mlCWd7Zzfk',
    appId: '1:210748048462:web:7e35209f056bc1842aaf1f',
    messagingSenderId: '210748048462',
    projectId: 'project-f0a4a',
    authDomain: 'project-f0a4a.firebaseapp.com',
    storageBucket: 'project-f0a4a.firebasestorage.app',
    measurementId: 'G-ETXFQPNE9Y',
  );

}