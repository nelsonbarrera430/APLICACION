import 'package:flutter/material.dart';

class LoginTitle extends StatelessWidget { // O StatefulWidget
  const LoginTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      'LOGIN',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.white,
        fontSize: 24.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}