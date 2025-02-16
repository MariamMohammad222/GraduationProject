
import 'package:flutter/widgets.dart';
import 'package:projectgraduation/constants/colorview.dart';

class Appbarwidget extends StatelessWidget {
  const Appbarwidget({super.key});

  @override
  Widget build(BuildContext context) {
    return  Align(
                  alignment: Alignment.topRight,
                  child: Text(
                    'Tcare',
                    style: TextStyle(
                      fontSize: 22,
                      fontFamily: "TimesNewRoman",
                      fontWeight: FontWeight.bold,
                      color: AppUI.colorSeconder,
                    ),
                  ),
     );
                
  }
}