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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAX7F9uEaqdduQLjFXyu5pwZx0pSaaupbw',
    appId: '1:718634784770:android:732b6b0f8858854d3caf1b',
    messagingSenderId: '718634784770',
    projectId: 'retailor-11-dd4d2',
    databaseURL: 'https://retailor-11-dd4d2-default-rtdb.firebaseio.com',
    storageBucket: 'retailor-11-dd4d2.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDp5bu8xWTNS0bjB8xbZ4MG-GIgeTXCH7I',
    appId: '1:718634784770:ios:69add278b39b53313caf1b',
    messagingSenderId: '718634784770',
    projectId: 'retailor-11-dd4d2',
    databaseURL: 'https://retailor-11-dd4d2-default-rtdb.firebaseio.com',
    storageBucket: 'retailor-11-dd4d2.appspot.com',
    iosClientId: '718634784770-tm2itkemsdjorsk3fk4vpf1c848p7e72.apps.googleusercontent.com',
    iosBundleId: 'com.example.retailor',
  );
}
