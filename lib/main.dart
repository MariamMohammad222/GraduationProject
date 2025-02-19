import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:projectgraduation/firebase_options.dart';
import 'package:projectgraduation/screens/fillinformationpage.dart';
import 'package:projectgraduation/screens/fillrelativesInformation.dart';
import 'package:projectgraduation/screens/homePageScreen.dart';
import 'package:projectgraduation/screens/profilePage.dart';
import 'package:projectgraduation/screens/mainScreen.dart';
import 'package:projectgraduation/screens/loginScreen.dart';
import 'package:projectgraduation/screens/onboardingPage.dart';
import 'package:projectgraduation/screens/signUppage.dart';
import 'package:projectgraduation/screens/splashScreen.dart';
import 'package:google_api_availability/google_api_availability.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();  
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
   GoogleApiAvailability apiAvailability = GoogleApiAvailability.instance;
  GooglePlayServicesAvailability status = await apiAvailability.checkGooglePlayServicesAvailability();

  runApp(const MyApp());  
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
       theme: ThemeData(
        primaryColor: const Color(0xFF1a237e),
        //scaffoldBackgroundColor: const Color(0xFF1a237e),
      ),
      debugShowCheckedModeBanner: false,
      routes: {
        login().id: (context) => login(),
        SignUpScreen().id: (context) => SignUpScreen(),
        HomeScreen().id: (context) => HomeScreen(),
         MainScreen().id: (context) => MainScreen(),
      
      },
      home:MainScreen(),
    );
  }
}

