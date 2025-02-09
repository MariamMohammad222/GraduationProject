import 'package:flutter/material.dart';
import 'package:projectgraduation/views/colorview.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final bool isPassword;
  final TextEditingController? controller;

  const CustomTextField({
    super.key,
    required this.hintText,
    required this.icon,
    this.isPassword = false,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        height: 55,
        child: TextFormField(
          controller: controller,
          obscureText: isPassword,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.grey),
            hintText: hintText,
            filled: true,
            fillColor: Colors.white,
            // border: OutlineInputBorder(
            //   borderRadius: BorderRadius.circular(22),
            //   borderSide: BorderSide.none,
            // ),
            focusedBorder: OutlineInputBorder( 
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide( 
                color: AppUI.colorSeconder
              ),
              
            ),
            enabledBorder:  OutlineInputBorder(
              borderRadius: BorderRadius.circular(16), 
              borderSide: BorderSide( 
                color: AppUI.colorSeconder
              ),
            )
          ),
        ),
      ),
    );
  }
}
