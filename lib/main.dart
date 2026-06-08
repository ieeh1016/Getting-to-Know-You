import 'package:flutter/material.dart';

import 'src/firebase/firebase_config.dart';
import 'src/ui/alagagi_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final firebaseEnabled = await initializeFirebaseIfConfigured();
  runApp(AlagagiApp(firebaseEnabled: firebaseEnabled));
}
