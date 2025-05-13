// widgets/pregunta_card.dart
import 'package:flutter/material.dart';

class PreguntaCard extends StatelessWidget {
  final String pregunta;
  final double respuestaActual;
  final ValueChanged<double> onRespuestaChanged;

  const PreguntaCard({
    Key? key,
    required this.pregunta,
    required this.respuestaActual,
    required this.onRespuestaChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Centra el contenido verticalmente
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              pregunta,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Slider(
              value: respuestaActual,
              min: 1,
              max: 10,
              divisions: 9,
              label: respuestaActual.round().toString(),
              activeColor: const Color.fromARGB(255, 0, 0, 0),
              inactiveColor: Colors.grey[300],
              onChanged: onRespuestaChanged,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('1 (Nada)', style: TextStyle(color: Colors.grey[600])),
                  Text('10 (Mucho)', style: TextStyle(color: Colors.grey[600])),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

