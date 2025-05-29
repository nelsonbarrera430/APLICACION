import 'package:flutter/material.dart';

class CircularBreathingDesign extends StatelessWidget {
  final bool isRunning;
  final String breathText;
  final double progress;
  final int timeRemaining;
  final VoidCallback onStartBreathing;

  // Paleta de colores nueva
  static const Color colorNegro = Color(0xFF000000);
  static const Color colorMorado = Color(0xFF2C003E);
  static const Color colorTomate = Color.fromARGB(255, 123, 45, 3); // Tomate
  static const Color colorFucsia = Color.fromARGB(255, 127, 44, 2); // Acento fucsia
  static const Color colorBlancoTransparente = Color(0xAAFFFFFF);

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
    if (step == 'Inhala') return 1.0 + 0.3 * progress;
    if (step == 'Exhala') return 1.3 - 0.3 * progress;
    return 1.15;
  }

  Color _getCircleColor(int index) {
    if (index == 2) return colorTomate;
    return index == 0 ? colorNegro : colorMorado;
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
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [colorNegro, colorMorado],
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Círculo exterior
            AnimatedScale(
              scale: _calculateCircleScale(breathText, progress),
              duration: const Duration(milliseconds: 200),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.7,
                height: MediaQuery.of(context).size.width * 0.7,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _getCircleColor(0),
                  boxShadow: [
                    BoxShadow(
                      color: colorFucsia.withOpacity(0.5),
                      blurRadius: 25,
                      spreadRadius: 10,
                    ),
                  ],
                ),
              ),
            ),
            // Círculo intermedio
            AnimatedScale(
              scale: _calculateCircleScale(breathText, progress) * 0.85,
              duration: const Duration(milliseconds: 250),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.6,
                height: MediaQuery.of(context).size.width * 0.6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _getCircleColor(1),
                  boxShadow: [
                    BoxShadow(
                      color: colorFucsia.withOpacity(0.4),
                      blurRadius: 20,
                      spreadRadius: 8,
                    ),
                  ],
                ),
              ),
            ),
            // Círculo central
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: MediaQuery.of(context).size.width * 0.45,
              height: MediaQuery.of(context).size.width * 0.45,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _getCircleColor(2),
                boxShadow: [
                  BoxShadow(
                    color: colorFucsia.withOpacity(0.6),
                    spreadRadius: 6,
                    blurRadius: 18,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  breathText,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: colorBlancoTransparente,
                    shadows: [
                      Shadow(
                        blurRadius: 6,
                        color: Colors.black,
                        offset: Offset(1, 1),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Temporizador y slider
            Positioned(
              bottom: 40,
              left: 20,
              right: 20,
              child: Column(
                children: [
                  Text(
                    _formatTime(timeRemaining),
                    style: const TextStyle(
                      fontSize: 20,
                      color: colorBlancoTransparente,
                    ),
                  ),
                  const SizedBox(height: 15),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 6,
                      activeTrackColor: colorTomate,
                      inactiveTrackColor: Colors.grey.shade800,
                      thumbColor: colorFucsia,
                      overlayColor: colorFucsia.withOpacity(0.3),
                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10.0),
                      overlayShape: const RoundSliderOverlayShape(overlayRadius: 18.0),
                    ),
                    child: Slider(
                      value: progress,
                      onChanged: (_) {},
                    ),
                  ),
                ],
              ),
            ),
            // Botón de inicio
            if (!isRunning)
              ElevatedButton(
                onPressed: onStartBreathing,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 18),
                  backgroundColor: colorFucsia,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: colorTomate, width: 2),
                  ),
                  elevation: 5,
                  shadowColor: Colors.black,
                ),
                child: const Text(
                  'Empezar',
                  style: TextStyle(fontSize: 20),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
