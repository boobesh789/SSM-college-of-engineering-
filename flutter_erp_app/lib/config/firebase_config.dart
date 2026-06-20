import 'package:firebase_core/firebase_core.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return android;
  }

  /// Android Firebase configuration
  /// Update with your actual Firebase project credentials from google-services.json
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'YOUR_ANDROID_API_KEY',
    appId: 'YOUR_ANDROID_APP_ID',
    messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
    projectId: 'ssm-student-hub',
    storageBucket: 'ssm-student-hub.appspot.com',
  );

  /// iOS Firebase configuration
  /// Update with your actual Firebase project credentials from GoogleService-Info.plist
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'YOUR_IOS_API_KEY',
    appId: 'YOUR_IOS_APP_ID',
    messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
    projectId: 'ssm-student-hub',
    storageBucket: 'ssm-student-hub.appspot.com',
    iosBundleId: 'com.ssm.student-hub',
  );
}
