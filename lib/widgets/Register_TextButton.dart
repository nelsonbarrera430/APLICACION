import 'package:flutter/material.dart';

class RegisterTextButton extends StatelessWidget {
  final VoidCallback onPressed;

  const RegisterTextButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: const Text(
        'No tienes cuenta? Regístrate',
        style: TextStyle(color: Colors.white70),
        textAlign: TextAlign.center,
      ),
    );
  }
}