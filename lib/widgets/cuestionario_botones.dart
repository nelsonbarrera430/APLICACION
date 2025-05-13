// widgets/cuestionario_botones.dart
import 'package:flutter/material.dart';

class CuestionarioBotones extends StatelessWidget {
  final int preguntaActualIndex;
  final int totalPreguntas;
  final VoidCallback onSiguientePressed;
  final VoidCallback? onAnteriorPressed;

  const CuestionarioBotones({
    Key? key,
    required this.preguntaActualIndex,
    required this.totalPreguntas,
    required this.onSiguientePressed,
    this.onAnteriorPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        if (preguntaActualIndex > 0 && onAnteriorPressed != null)
          ElevatedButton(
            onPressed: onAnteriorPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 255, 255, 255),
              foregroundColor: const Color.fromARGB(255, 0, 0, 0),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: const Text('Anterior', style: TextStyle(fontSize: 16)),
          ),
        ElevatedButton(
          onPressed: onSiguientePressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 0, 0, 0),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          child: Text(
            preguntaActualIndex < totalPreguntas - 1
                ? 'Siguiente'
                : 'Finalizar', // Más corto y directo
            style: const TextStyle(fontSize: 16),
          ),
        ),
        if (preguntaActualIndex == 0 && onAnteriorPressed != null)
          const SizedBox(width: 130), // Para alinear el botón "Siguiente"
      ],
    );
  }
}