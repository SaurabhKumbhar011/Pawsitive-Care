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
    apiKey: 'AIzaSyD7x3QgcfkCIPQWFkaD5tr_yxoKLwAYRlM',
    appId: '1:889133802838:web:18f11dfc2003dc0d0562f7',
    messagingSenderId: '889133802838',
    projectId: 'paw1-f20db',
    authDomain: 'paw1-f20db.firebaseapp.com',
    storageBucket: 'paw1-f20db.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDhQpXLdGvsp-s_1c0HDlbAAKNU8RjDni4',
    appId: '1:889133802838:android:3f600481cd23c73e0562f7',
    messagingSenderId: '889133802838',
    projectId: 'paw1-f20db',
    storageBucket: 'paw1-f20db.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDqfbMAcz8xVlCT7f-jzNk9nuqGsEG9NgM',
    appId: '1:889133802838:ios:19633458c67dacfc0562f7',
    messagingSenderId: '889133802838',
    projectId: 'paw1-f20db',
    storageBucket: 'paw1-f20db.firebasestorage.app',
    iosBundleId: 'com.example.paw1',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDqfbMAcz8xVlCT7f-jzNk9nuqGsEG9NgM',
    appId: '1:889133802838:ios:19633458c67dacfc0562f7',
    messagingSenderId: '889133802838',
    projectId: 'paw1-f20db',
    storageBucket: 'paw1-f20db.firebasestorage.app',
    iosBundleId: 'com.example.paw1',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyD7x3QgcfkCIPQWFkaD5tr_yxoKLwAYRlM',
    appId: '1:889133802838:web:233a2b1eafbf472f0562f7',
    messagingSenderId: '889133802838',
    projectId: 'paw1-f20db',
    authDomain: 'paw1-f20db.firebaseapp.com',
    storageBucket: 'paw1-f20db.firebasestorage.app',
  );
}
