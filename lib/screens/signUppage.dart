import 'package:flutter/material.dart';
import 'package:projectgraduation/views/colorview.dart';
import 'package:projectgraduation/widgets/textfieldwidget.dart';


class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Center(
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 160),
                 Text(
                  "Sign up",
                  style: TextStyle(fontSize:55, fontWeight:FontWeight.w900, color: AppUI.colorPrimary,fontFamily:"TimesNewRoman"),
                ),
                const SizedBox(height: 20),
            
                // حقول الإدخال
                const CustomTextField(hintText: "Email", icon: Icons.email),
                const CustomTextField(hintText: "Username", icon: Icons.person),
                const CustomTextField(hintText: "Password", icon: Icons.lock, isPassword: true),
                const CustomTextField(hintText: "Confirm Password", icon: Icons.lock, isPassword: true),
            
                const SizedBox(height: 20),
            
               
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppUI.colorPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child:  Text(
                      "Sign up",
                      style: TextStyle(fontSize: 24, color:Colors.white,fontFamily:"TimesNewRoman"),
                    ),
                  ),
                ),
            
                const SizedBox(height: 20),
            
                
                const Text("OR login with", style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Image.asset("assets/images/Facebook.png"), 
                      iconSize: 40,
                      onPressed: () {},
                    ),
                    const SizedBox(width: 20),
                    IconButton(
                      icon: Image.asset("assets/images/google 1.png"), 
                      iconSize: 40,
                      onPressed: () {},
                    ),
                  ],
                ),
            
                const SizedBox(height: 20),
            
               
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Have an account? "),
                    GestureDetector(
                      onTap: () {
                        
                      },
                      child: Text(
                        "Login",
                        style: TextStyle(color: AppUI.colorPrimary, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
