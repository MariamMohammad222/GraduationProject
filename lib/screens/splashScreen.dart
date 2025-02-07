import 'dart:async';

import 'package:flutter/material.dart';
import 'package:projectgraduation/screens/onboardingPage.dart';
import 'package:projectgraduation/views/colorview.dart';
class TcareScreen extends StatefulWidget {
  @override
  State<TcareScreen> createState() => _TcareScreenState();
}

class _TcareScreenState extends State<TcareScreen> {
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 15),(){
      Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder:(context) => OnboardingScreen()),(route) => false);

    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppUI.colorPrimary, // لون الخلفية الأزرق
      body: Container(
               decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppUI.colorSeconder,
              AppUI.colorPrimary, // لون أزرق داكن (بداية التدرج)
              // لون أفتح (نهاية التدرج)
            ],
            begin: Alignment.topCenter, // التدرج يبدأ من الأعلى
            end: Alignment.bottomCenter, // التدرج ينتهي في الأسفل
          ),
               ),

        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: 80,
              child: Text(
                'Tcare',
                style: TextStyle(
                  fontSize: 80,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                 fontFamily: "TimesNewRoman"
                ),
              ),
            ),
            Positioned(
              bottom:-40,
              child: Column(
                children: [
                
                  
                  Image.asset(
                    'assets/images/Group 39 (1).png', // صورة القفاز
                    width: 450
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}