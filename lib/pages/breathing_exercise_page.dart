import 'package:flutter/material.dart';
import '../core/breathing_timer.dart';
import '../widgets/circular_breathing_design.dart'; // Importa el nuevo diseño

class BreathingExercisePage extends StatefulWidget {
  @override
  _BreathingExercisePageState createState() => _BreathingExercisePageState();
}

class _BreathingExercisePageState extends State<BreathingExercisePage> {
  late BreathingTimer _breathingTimer;
  String _breathText = '';
  double _progress = 0.0;
  int _timeRemaining = 0;
  bool _isRunning = false;
  bool _hasFinished = false;

  final List<String> _breathingSteps = [
    'Inhala',
    'Mantén',
    'Exhala',
    'Mantén',
  ];

  @override
  void initState() {
    super.initState();
    _breathingTimer = BreathingTimer(
      steps: _breathingSteps,
      stepDurationSeconds: 4,
      onTick: _onTimerTick,
      onFinish: _onTimerFinish,
      totalCycles: 4, // ¡Aquí especificamos 4 ciclos!
    );
  }

  void _onTimerTick(String text, double progress, int timeRemaining) {
    setState(() {
      _breathText = text;
      _progress = progress;
      _timeRemaining = timeRemaining;
    });
  }

  void _onTimerFinish() {
    setState(() {
      _hasFinished = true;
      _isRunning = false;
      _progress = 1.0;
      _breathText = '¡Bien hecho!';
    });
  }

  void _startBreathing() {
    setState(() {
      _isRunning = true;
      _hasFinished = false;
      _breathText = _breathingSteps.first;
      _progress = 0.0;
      _timeRemaining = _breathingTimer.stepDurationSeconds;
    });
    _breathingTimer.start();
  }

  @override
  void dispose() {
    _breathingTimer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ejercicio de Respiración'),
        centerTitle: true,
        backgroundColor: Colors.black87, // Fondo oscuro para el AppBar
      ),
      body: CircularBreathingDesign(
        isRunning: _isRunning,
        breathText: _breathText,
        progress: _progress,
        timeRemaining: _timeRemaining,
        onStartBreathing: _startBreathing,
      ),
    );
  }
}