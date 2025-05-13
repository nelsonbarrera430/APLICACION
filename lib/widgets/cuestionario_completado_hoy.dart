// widgets/cuestionario_completado_hoy.dart
import 'package:flutter/material.dart';

class CuestionarioCompletadoHoy extends StatelessWidget {
  const CuestionarioCompletadoHoy({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Text(
          'Ya has completado el cuestionario de ansiedad hoy. ¡Vuelve mañana!',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}