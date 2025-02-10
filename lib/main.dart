import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:projectgraduation/firebase_options.dart';
import 'package:projectgraduation/screens/homescreen.dart';
import 'package:projectgraduation/screens/loginScreen.dart';
import 'package:projectgraduation/screens/onboardingPage.dart';
import 'package:projectgraduation/screens/signUppage.dart';
import 'package:projectgraduation/screens/splashScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();  // ✅ تأكد من تهيئة الـ binding أولًا
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());  // ✅ تأكد من تشغيل التطبيق بعد التهيئة
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        login().id: (context) => login(),
        SignUpScreen().id: (context) => SignUpScreen(),
        HomeScreen().id: (context) => HomeScreen(),
      },
      home: TcareScreen()
    );
  }
}

