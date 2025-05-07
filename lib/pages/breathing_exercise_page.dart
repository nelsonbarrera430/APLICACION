import 'package:flutter/material.dart';
import '../core/breathing_timer.dart';

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
      _timeRemaining = 0;
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
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!_isRunning && !_hasFinished) ...[
                ElevatedButton(
                  onPressed: _startBreathing,
                  child: Text('¿Quieres respirar?'),
                  style: ElevatedButton.styleFrom(
                    textStyle: TextStyle(fontSize: 20),
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                ),
              ] else if (_isRunning) ...[
                Text(
                  _breathText,
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 24),
                LinearProgressIndicator(
                  value: _progress,
                  minHeight: 12,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                ),
                SizedBox(height: 12),
                Text(
                  'Tiempo restante: $_timeRemaining s',
                  style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                ),
              ] else if (_hasFinished) ...[
                Text(
                  _breathText,
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _startBreathing,
                  child: Text('¿Quieres intentarlo de nuevo?'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    textStyle: TextStyle(fontSize: 18),
                    padding: EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}