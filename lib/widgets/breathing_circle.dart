import 'package:flutter/material.dart';

class BreathingCircle extends StatelessWidget {
  final double scale;
  final Color color;
  final String text;
  final BoxShape shape;
  final Duration duration;

  const BreathingCircle({
    Key? key,
    required this.scale,
    required this.color,
    required this.text,
    required this.shape,
    this.duration = const Duration(milliseconds: 1500),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: scale,
      duration: duration,
      child: AnimatedContainer(
        duration: duration,
        width: 160.0,
        height: 160.0,
        decoration: BoxDecoration(
          shape: shape,
          color: color,
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 24.0,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
