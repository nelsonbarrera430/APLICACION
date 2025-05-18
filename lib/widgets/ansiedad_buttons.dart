import 'package:flutter/material.dart';

class AnsiedadButtons extends StatelessWidget {
  final int puntajeAnsiedad;
  final VoidCallback onEjerciciosPressed;
  final VoidCallback onEmergenciaPressed;

  const AnsiedadButtons({
    Key? key,
    required this.puntajeAnsiedad,
    required this.onEjerciciosPressed,
    required this.onEmergenciaPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: onEjerciciosPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 255, 119, 0),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 15),
          ),
          child: const Text(
            'Ejercicios para calmarte',
            style: TextStyle(fontSize: 16),
          ),
        ),
        if (puntajeAnsiedad >= 7)
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: ElevatedButton(
              onPressed: onEmergenciaPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade400,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: const Text(
                'Botón de Emergencia',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
      ],
    );
  }
}
