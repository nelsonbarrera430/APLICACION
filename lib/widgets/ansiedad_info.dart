import 'package:flutter/material.dart';

class AnsiedadInfo extends StatelessWidget {
  final int puntajeAnsiedad;

  const AnsiedadInfo({Key? key, required this.puntajeAnsiedad}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Tu puntaje de ansiedad promedio es: $puntajeAnsiedad',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        const Text(
          'Este gráfico muestra el promedio de tu nivel de ansiedad para cada día que completaste el cuestionario.',
          style: TextStyle(fontStyle: FontStyle.italic),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
