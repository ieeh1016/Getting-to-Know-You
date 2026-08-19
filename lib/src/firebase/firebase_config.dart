import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class FirebaseConfig {
  static const apiKey = String.fromEnvironment('FIREBASE_API_KEY');
  static const appId = String.fromEnvironment('FIREBASE_APP_ID');
  static const messagingSenderId = String.fromEnvironment(
    'FIREBASE_MESSAGING_SENDER_ID',
  );
  static const projectId = String.fromEnvironment('FIREBASE_PROJECT_ID');
  static const authDomain = String.fromEnvironment('FIREBASE_AUTH_DOMAIN');
  static const storageBucket = String.fromEnvironment(
    'FIREBASE_STORAGE_BUCKET',
  );

  static bool get isConfigured {
    return apiKey.isNotEmpty &&
        appId.isNotEmpty &&
        messagingSenderId.isNotEmpty &&
        projectId.isNotEmpty;
  }

  static FirebaseOptions get options {
    return FirebaseOptions(
      apiKey: apiKey,
      appId: appId,
      messagingSenderId: messagingSenderId,
      projectId: projectId,
      authDomain: authDomain.isEmpty ? null : authDomain,
      storageBucket: storageBucket.isEmpty ? null : storageBucket,
    );
  }
}

Future<bool> initializeFirebaseIfConfigured() async {
  if (!FirebaseConfig.isConfigured) {
    return false;
  }
  await Firebase.initializeApp(options: FirebaseConfig.options);
  // 여행은 이 앱에서 유일하게 집 밖에서 쓰는 기능이다. 비행기나 로밍을 끈
  // 해외에서 새로고침해도 마지막에 본 내용이 남아야 한다. 무료 플랜 범위다.
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );
  return true;
}
