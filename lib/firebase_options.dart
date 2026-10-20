import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      default:
        return android;
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCuQhKBbeuRILn6Pm3yodEwGSiXx6Khs40',
    appId: '1:993808199190:android:8baf4821de213c15650f37',
    messagingSenderId: '993808199190',
    projectId: 'ruang-cerita-c1e8a',
    storageBucket: 'ruang-cerita-c1e8a.firebasestorage.app',
  );
}
