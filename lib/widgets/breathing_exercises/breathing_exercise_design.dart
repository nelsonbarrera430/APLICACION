import 'package:flutter/material.dart';

class CurvedProgressBarPainter extends CustomPainter {
  final double progress;
  final Color activeColor;
  final Color inactiveColor;

  CurvedProgressBarPainter({
    required this.progress,
    required this.activeColor,
    required this.inactiveColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Define los parámetros de la curva
    const double curvature = 30.0;
    final double startX = 0;
    final double endX = size.width;
    final double centerY = size.height / 2;
    final double halfX = endX / 2;

    // 1. Dibujar la parte inactiva (fondo) de la barra
    final inactivePaint = Paint()
      ..color = inactiveColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;
    Path inactivePath = Path();
    inactivePath.moveTo(startX, centerY);
    inactivePath.quadraticBezierTo(
      halfX, centerY - curvature,
      endX, centerY,
    );
    canvas.drawPath(inactivePath, inactivePaint);

    // 2. Dibujar la parte activa (progreso) de la barra
    final activePaint = Paint()
      ..color = activeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;
    Path activePath = Path();
    activePath.moveTo(startX, centerY);
    double activeEndX = startX + progress * (endX - startX);
    activeEndX = activeEndX.clamp(startX, endX);
    double activeControlX = activeEndX / 2;
    double activeControlY = centerY - curvature * (activeEndX / endX);
    activePath.quadraticBezierTo(
      activeControlX, activeControlY,
      activeEndX, centerY,
    );
    canvas.drawPath(activePath, activePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class CircularBreathingDesign extends StatelessWidget {
  final bool isRunning;
  final String breathText;
  final double progress;
  final int timeRemaining;
  final VoidCallback onStartBreathing;

  static const Color colorAzulOscuro1 = Color(0xB3304FFE);
  static const Color colorAzulOscuro2 = Color(0xB32962FF);
  static const Color colorAzulMedio = Color(0xB31E88E5);
  static const Color colorNegroProfundo = Color(0xFF000000);
  static const Color colorMoradoOscuroDegradado = Color(0xFF30193D);
  static const Color colorBotonEmpezarElegante = Color(0xFF304FFE);

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

    // Umbrales ajustados para movimientos más bruscos
    double threshold1 = 0.1; // 10% del progreso
    double threshold2 = 0.3; // 30% del progreso
    double threshold3 = 0.6; // 60% del progreso

    if (step == 'Inhala') {
      if (progress < threshold1) {
        return 1.0;
      } else if (progress < threshold2) {
        return 1.2; // Salto mayor al 120%
      } else if (progress < threshold3) {
        return 1.4;
      } else {
        return 1.6; // Salto aún mayor
      }
    } else if (step == 'Exhala') {
      if (progress < threshold1) {
        return 1.6;
      } else if (progress < threshold2) {
        return 1.4;
      } else if (progress < threshold3) {
        return 1.2;
      } else {
        return 1.0;
      }
    } else {
      return 1.1;
    }
  }

  Color _getCircleColor(int index) {
    const colors = [
      colorAzulOscuro1,
      colorAzulOscuro2,
      colorAzulMedio,
    ];
    return colors[(colors.length - 1 - index) % colors.length];
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
            // Temporizador y control (barra de progreso curva)
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
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: 20,
                    child: CustomPaint(
                      painter: CurvedProgressBarPainter(
                        progress: progress,
                        activeColor: colorAzulMedio,
                        inactiveColor: Colors.grey.shade800,
                      ),
                      size: Size(MediaQuery.of(context).size.width * 0.8, 20),
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
                  backgroundColor: const Color.fromARGB(255, 0, 0, 0),
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

