import 'package:flutter/material.dart';
import 'dart:math';
import 'particle.dart';
import 'particle_painter.dart';

class ParticleEffect extends StatefulWidget {
  final String breathingText;

  const ParticleEffect({Key? key, required this.breathingText}) : super(key: key);

  @override
  State<ParticleEffect> createState() => _ParticleEffectState();
}

class _ParticleEffectState extends State<ParticleEffect> {
  final List<Particle> _particles = [];
  final Random _random = Random();

  @override
  void didUpdateWidget(covariant ParticleEffect oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.breathingText == 'Exhala' && _random.nextDouble() > 0.5) {
      _particles.add(
        Particle(
          x: MediaQuery.of(context).size.width / 2 + (_random.nextDouble() - 0.5) * 100,
          y: MediaQuery.of(context).size.height / 2 + (_random.nextDouble() - 0.5) * 100,
          color: Colors.red.shade100.withOpacity(0.8),
          size: _random.nextDouble() * 8 + 4,
          speedX: (_random.nextDouble() - 0.5) * 3,
          speedY: (_random.nextDouble() - 1.0) * 3,
          opacity: 1.0,
        ),
      );
    }

    for (var i = _particles.length - 1; i >= 0; i--) {
      _particles[i].update();
      if (_particles[i].opacity <= 0.01) {
        _particles.removeAt(i);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: ParticlePainter(_particles),
      size: MediaQuery.of(context).size,
    );
  }
}