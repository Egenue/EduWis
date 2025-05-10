import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAfE9kx1-VPdl9KeZBGGRQB99F1OyAhoIE',
    appId: '1:255222934814:web:69fe505a4aac4df3daed0f',
    messagingSenderId: 'your-sender-id',
    projectId: 'eduwise-ccf6b',
    authDomain: 'eduwise-ccf6b.firebaseapp.com',
    storageBucket: 'eduwise-ccf6b.firebasestorage.app',
    measurementId: 'G-LB9Q4ME9G8',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB4XdSw2DLIHjxIRj9s7n5GCBzCSHzCNsE',
    appId: '1:255222934814:android:4e040f0c810f47b8daed0f',
    messagingSenderId: '255222934814',
    projectId: 'eduwise-ccf6b',
    storageBucket: 'eduwise-ccf6b.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'your-ios-api-key',
    appId: 'your-ios-app-id',
    messagingSenderId: 'your-sender-id',
    projectId: 'your-project-id',
    storageBucket: 'your-storage-bucket',
    iosClientId: 'your-ios-client-id',
    iosBundleId: 'your-ios-bundle-id',
  );
}