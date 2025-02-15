import 'package:flutter/material.dart';
import 'package:projectgraduation/constants/colorview.dart';

class nextwidget extends StatelessWidget {
  const nextwidget({super.key});

  @override
  Widget build(BuildContext context) {
    return  Center(
                child: SizedBox(
                 
                  child: Center(
                    child: Container(
                       width: 140,
                       height: 55,
                      decoration: BoxDecoration( 
                        borderRadius: BorderRadius.circular(24),
                        color: AppUI.colorPrimary
                      ),
                     child: Center(
                       child: Text("Next",
                            style: TextStyle(
                                fontSize: 24,
                                color: Colors.white,
                                fontFamily: AppUI.fontarial)),
                     ),
                    ),
                  )
                    
              ),
    );
  }
}