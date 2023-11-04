import 'package:flutter/material.dart';
import 'package:task_back4app/components/login.dart';
import 'package:task_back4app/components/signup.dart';

class AuthScreen extends StatefulWidget {
  static const route = "/auth-screen";

  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  var isSigningUp = false;

  void toggleIsSigningUp() {
    setState(() {
      isSigningUp = !isSigningUp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isSigningUp
          ? SignupPage(toggleIsSigningUp: toggleIsSigningUp)
          : LoginPage(toggleIsSigningUp: toggleIsSigningUp),
    );
  }
}
