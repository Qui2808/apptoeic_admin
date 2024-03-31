
import 'package:apptoeic_admin/splashscreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyAZ0oFqwT0ih6fPuZAUOig54DCgm0wqpIg",
          appId: "1:737044940192:android:d310c3099c2acb13b510c5",
          messagingSenderId: "737044940192",
          projectId: "apptoeic-a4ce0"));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
