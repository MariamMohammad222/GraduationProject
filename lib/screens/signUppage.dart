import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projectgraduation/screens/homescreen.dart';
import 'package:projectgraduation/screens/loginScreen.dart';
import 'package:projectgraduation/views/colorview.dart';
import 'package:projectgraduation/widgets/textfieldwidget.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  final String id = 'sign up';

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  String? email, username, password, confirmPassword;

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email!, password: password!);

      // Save user data in Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'email': email,
        'username': username,
        'createdAt': DateTime.now(),
      });

      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration successful!')),
      );

      
      Navigator.pushReplacementNamed(context, HomeScreen().id);
    } on FirebaseAuthException catch (e) {
      String errorMessage = "An error occurred, please try again!";
      if (e.code == 'weak-password') {
        errorMessage = "Weak password, please use a stronger one.";
      } else if (e.code == 'email-already-in-use') {
        errorMessage = "This email is already in use.";
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage)));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred, please try again!')),
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
                const SizedBox(height: 90),
                Text(
                  "Sign up",
                  style: TextStyle(
                      fontSize: 55,
                      fontWeight: FontWeight.w900,
                      color: AppUI.colorPrimary,
                      fontFamily: "TimesNewRoman"),
                ),
                const SizedBox(height: 20),

                CustomTextField(
                  hintText: "Email",
                  icon: Icons.email,
                  onChanged: (value) => email = value,
                  validator: (value) =>
                      value!.isEmpty ? "Email is required" : null,
                ),
                CustomTextField(
                  hintText: "Username",
                  icon: Icons.person,
                  onChanged: (value) => username = value,
                  validator: (value) =>
                      value!.isEmpty ? "Username is required" : null,
                ),
                CustomTextField(
                  hintText: "Password",
                  icon: Icons.lock,
                  isPassword: true,
                  onChanged: (value) => password = value,
                  validator: (value) {
                    if (value!.isEmpty) return "Password is required";
                    if (value.length < 6)
                      return "Password must be at least 6 characters";
                    return null;
                  },
                ),
                CustomTextField(
                  hintText: "Confirm Password",
                  icon: Icons.lock,
                  isPassword: true,
                  onChanged: (value) => confirmPassword = value,
                  validator: (value) =>
                      value != password ? "Passwords do not match" : null,
                ),

                const SizedBox(height: 20),

                _isLoading
                    ? CircularProgressIndicator()
                    : SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                        onPressed: _signUp,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppUI.colorPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          child: Text(
                            "Sign up",
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
                    const Text("Have an account? "),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, login().id);
                      },
                      child: Text(
                        "Login",
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
    );
  }
}
