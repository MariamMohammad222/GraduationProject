import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projectgraduation/screens/homescreen.dart';
import 'package:projectgraduation/screens/signUppage.dart';
import 'package:projectgraduation/constants/colorview.dart';
import 'package:projectgraduation/widgets/textfieldwidget.dart';
class login extends StatefulWidget {
  const login ({super.key});
  final String id = 'login page';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<login> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _login() async 
  {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: _emailController.text, password: _passwordController.text);

      
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      if (!userDoc.exists) {
        throw Exception("User not found ");
      }

      // عرض رسالة نجاح
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login successful!')),
      );

      
      Navigator.pushReplacementNamed(context, HomeScreen().id); 

    } on FirebaseAuthException catch (e) {
      String errorMessage = "An error occurred, please try again!";
      if (e.code == 'user-not-found') {
        errorMessage = "No user found with this email.";
      } else if (e.code == 'wrong-password') {
        errorMessage = "Incorrect password.";
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(errorMessage)));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred, please try again!')),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Align(
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
                  ),
                  const SizedBox(height: 140),
                  Text(
                    "Login",
                    style: TextStyle(
                        fontSize: 55,
                        fontWeight: FontWeight.w900,
                        color: AppUI.colorPrimary,
                        fontFamily: "TimesNewRoman"),
                  ),
                  const SizedBox(height: 30),

                  // Email Field
                  CustomTextField(
                    hintText: "Email",
                    icon: Icons.email,
                    controller: _emailController,
                    validator: (value) =>
                        value!.isEmpty ? "Email is required" : null,
                  ),
                  const SizedBox(height: 20),

                  // Password Field
                  CustomTextField(
                    hintText: "Password",
                    icon: Icons.lock,
                    isPassword: true,
                    controller: _passwordController,
                    validator: (value) =>
                        value!.isEmpty ? "Password is required" : null,
                  ),

                  const SizedBox(height: 20),

                  // Login Button
                  _isLoading
                      ? const CircularProgressIndicator()
                      : SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppUI.colorPrimary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                            child: const Text(
                              "Login",
                              style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.white,
                                  fontFamily: "TimesNewRoman"),
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
                      const Text("Don't have an account? "),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, SignUpScreen().id);
                        },
                        child: Text(
                          "Sign up",
                          style: TextStyle(
                              color: AppUI.colorPrimary,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

