import 'package:flutter/material.dart';
class TcareScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[800], // لون الخلفية الأزرق
      body: Container(
               decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(48, 81, 156, 1),
              Color(0X07173C), // لون أزرق داكن (بداية التدرج)
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