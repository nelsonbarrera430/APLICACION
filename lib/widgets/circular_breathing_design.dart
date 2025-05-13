import 'package:flutter/material.dart';
import 'dart:math';

class CircularBreathingDesign extends StatelessWidget {
  final bool isRunning;
  final String breathText;
  final double progress;
  final int timeRemaining;
  final VoidCallback onStartBreathing;

  static const Color colorAzulOscuro1 = Color.fromARGB(179, 0, 0, 0);   // Azul oscuro con opacidad
  static const Color colorAzulOscuro2 = Color.fromARGB(179, 0, 0, 0);   // Azul oscuro ligeramente más claro con opacidad
  static const Color colorAzulMedio = Color.fromARGB(179, 255, 255, 255);    // Azul medio con opacidad
  static const Color colorNegroProfundo = Color(0xFF000000);   // Negro profundo (inicio del degradado)
  static const Color colorMoradoOscuroDegradado = Color(0xFF30193D); // Morado oscuro (fin del degradado)
  static const Color colorBotonEmpezarElegante = Color(0xFF304FFE); // Azul oscuro para el botón

  const CircularBreathingDesign({
    Key? key,
    required this.isRunning,
    required this.breathText,
    required this.progress,
    required this.timeRemaining,
    required this.onStartBreathing,
  }) : super(key: key);

  double _calculateCircleScale(String step, double progress) {
    if (!isRunning) return 1.0;
    if (step == 'Inhala') {
      return 1.0 + 0.2 * progress;
    } else if (step == 'Exhala') {
      return 1.2 - 0.2 * progress;
    } else {
      return 1.1; // Para 'Mantén'
    }
  }

  Color _getCircleColor(int index) {
    const colors = [
      colorAzulOscuro1,
      colorAzulOscuro2,
      colorAzulMedio,
    ];
    return colors[(colors.length - 1 - index) % colors.length]; // Invertir el orden para el exterior más oscuro
  }

  String _formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              colorNegroProfundo,
              colorMoradoOscuroDegradado,
            ],
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Círculos concéntricos
            AnimatedScale(
              scale: _calculateCircleScale(breathText, progress),
              duration: const Duration(milliseconds: 200),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.6,
                height: MediaQuery.of(context).size.width * 0.6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _getCircleColor(0),
                ),
              ),
            ),
            AnimatedScale(
              scale: _calculateCircleScale(breathText, progress) * 0.8,
              duration: const Duration(milliseconds: 250),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.5,
                height: MediaQuery.of(context).size.width * 0.5,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _getCircleColor(1),
                ),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: MediaQuery.of(context).size.width * 0.4,
              height: MediaQuery.of(context).size.width * 0.4,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _getCircleColor(2),
              ),
              child: Center(
                child: Text(
                  breathText,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            // Temporizador y control
            Positioned(
              bottom: 40,
              left: 20,
              right: 20,
              child: Column(
                children: [
                  Text(
                    _formatTime(timeRemaining),
                    style: TextStyle(fontSize: 18, color: Colors.white70),
                  ),
                  SizedBox(height: 10),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 5,
                      activeTrackColor: colorAzulMedio,
                      inactiveTrackColor: Colors.grey.shade800,
                      thumbColor: Colors.white,
                      overlayColor: Colors.white.withOpacity(0.3),
                      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8.0),
                      overlayShape: RoundSliderOverlayShape(overlayRadius: 14.0),
                      // Personalización adicional para que se vea más como una barra
                      tickMarkShape: RoundSliderTickMarkShape(),
                      inactiveTickMarkColor: Colors.transparent,
                      activeTickMarkColor: Colors.transparent,
                    ),
                    child: Slider(
                      value: progress,
                      onChanged: (double value) {
                        // Puedes implementar lógica para controlar el tiempo aquí si lo deseas
                      },
                    ),
                  ),
                ],
              ),
            ),
            // Botón de inicio si no está corriendo
            if (!isRunning)
              ElevatedButton(
                onPressed: onStartBreathing,
                child: Text('Empezar', style: TextStyle(fontSize: 18)),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  backgroundColor: colorBotonEmpezarElegante,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}