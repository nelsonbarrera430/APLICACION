import 'package:flutter/material.dart';

class CuestionarioCargando extends StatelessWidget {
  const CuestionarioCargando({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator(color: Colors.deepPurple));
  }
}