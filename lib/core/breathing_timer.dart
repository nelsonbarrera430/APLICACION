import 'dart:async';

class BreathingTimer {
  final Function(String text, double progress, int timeRemaining) onTick;
  final Function onFinish;
  final List<String> steps;
  final int stepDurationSeconds;
  final int totalCycles; // Añadimos el número total de ciclos

  Timer? _timer;
  int _currentStepIndex = 0;
  int _stepTimePassed = 0;
  double _progress = 0.0;
  int _cycleCount = 0; // Contador de ciclos

  int get _stepDurationMs => stepDurationSeconds * 1000;

  BreathingTimer({
    required this.steps,
    required this.stepDurationSeconds,
    required this.onTick,
    required this.onFinish,
    this.totalCycles = 1, // Valor por defecto de 1 ciclo
  });

  void start() {
    _currentStepIndex = 0;
    _stepTimePassed = 0;
    _progress = 0.0;
    _cycleCount = 0; // Reiniciamos el contador de ciclos al iniciar
    _startStep();
  }

  void _startStep() {
    _stepTimePassed = 0;
    _progress = 0.0;

    _timer?.cancel();
    _timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      _stepTimePassed += 100;
      _progress = _stepTimePassed / _stepDurationMs;

      int timeRemaining = ((_stepDurationMs - _stepTimePassed) / 1000).ceil();

      if (_stepTimePassed >= _stepDurationMs) {
        timer.cancel();
        _nextStep();
      } else {
        onTick(
          steps[_currentStepIndex % steps.length], // Usamos el módulo para repetir los pasos
          _progress.clamp(0.0, 1.0),
          timeRemaining,
        );
      }
    });
  }

  void _nextStep() {
    _currentStepIndex++;
    if (_currentStepIndex % steps.length == 0) {
      _cycleCount++; // Incrementamos el contador de ciclos al completar una secuencia de pasos
      if (_cycleCount >= totalCycles) {
        onFinish(); // Detenemos si alcanzamos el número total de ciclos
        return;
      }
    }
    _startStep();
  }

  void dispose() {
    _timer?.cancel();
  }
}