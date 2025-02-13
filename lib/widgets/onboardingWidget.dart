import 'package:flutter/material.dart';
import 'package:projectgraduation/models/onboardingModel.dart';
import 'package:projectgraduation/constants/colorview.dart';

class onboardingWidget extends StatelessWidget {
   onboardingWidget({
    super.key,
    required this.model,
  });

  final OnboardingModel model;

  @override
  Widget build(BuildContext context) {
    return Column(
     mainAxisAlignment: MainAxisAlignment.center,
     children: [
      
       
       Image.asset(
         model.imagePath,
         // height: 250,
         // width: double.infinity,
       ),
       
       Text(
         model.heading,
         textAlign: TextAlign.center,
         style: TextStyle(
           fontSize: 36,
           fontWeight: FontWeight.bold,
            fontFamily: "TimesNewRoman",
           color:AppUI.colorPrimary,
         ),
       ),
       const SizedBox(height: 10),
       Padding(
         padding: const EdgeInsets.all(9),
         child: Text(
          model.description,
           
           textAlign: TextAlign.center,
           style:TextStyle(
             fontSize:20,
             color: AppUI.colorSeconder,
             fontFamily: "TimesNewRoman",
           ),
         ),
       ),
       
     ],
            );
  }
}
