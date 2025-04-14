import 'dart:async';
import 'package:flutter/material.dart';
import 'package:projectgraduation/screens/onboardingPage.dart';
import 'package:projectgraduation/constants/colorview.dart';

class TcareScreen extends StatefulWidget {
  @override
  State<TcareScreen> createState() => _TcareScreenState();
}

class _TcareScreenState extends State<TcareScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeInAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    
    // Initialize animation controller
    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    );

    // Fade in animation for the text
    _fadeInAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Interval(0.0, 0.5, curve: Curves.easeIn),
    ));

    // Slide animation for the text
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, -0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Interval(0.0, 0.5, curve: Curves.easeOut),
    ));

    // Scale animation for the image
    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Interval(0.3, 0.8, curve: Curves.elasticOut),
    ));

    // Start the animation
    _controller.forward();

    // Navigate to next screen after 20 seconds
    Timer(const Duration(seconds: 5), () {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => OnboardingScreen()),
        (route) => false,
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppUI.colorPrimary,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppUI.colorSeconder,
              AppUI.colorPrimary,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Animated Text
            Positioned(
              top: 80,
              child: SlideTransition(
                position: _slideAnimation,
                child: FadeTransition(
                  opacity: _fadeInAnimation,
                  child: Text(
                    'Tcare',
                    style: TextStyle(
                      fontSize: 80,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: "TimesNewRoman",
                    ),
                  ),
                ),
              ),
            ),
            // Animated Image
            Positioned(
              bottom: -40,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/Group 39 _1.png',
                      width: 450,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
