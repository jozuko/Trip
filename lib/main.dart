import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:trip/firebase_options.dart';
import 'package:trip/view/init/application.dart';

Future<void> main() async {
  // TODO BLOCとGET-ITの導入
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const Application());
}
