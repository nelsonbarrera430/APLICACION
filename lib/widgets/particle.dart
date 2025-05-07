import 'package:flutter/material.dart';

class Particle {
  double x;
  double y;
  Color color;
  double size;
  double speedX;
  double speedY;
  double opacity;

  Particle({
    required this.x,
    required this.y,
    required this.color,
    required this.size,
    required this.speedX,
    required this.speedY,
    required this.opacity,
  });

  void update() {
    x += speedX;
    y += speedY;
    opacity -= 0.03; // Velocidad de desvanecimiento
  }
}