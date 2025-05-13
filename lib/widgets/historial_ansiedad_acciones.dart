import 'package:flutter/material.dart';
import '../widgets/ansiedad_buttons.dart';

class HistorialAnsiedadAcciones extends StatelessWidget {
  final int puntajeAnsiedad;
  final VoidCallback onEjerciciosPressed;
  final VoidCallback onEmergenciaPressed;

  const HistorialAnsiedadAcciones({
    Key? key,
    required this.puntajeAnsiedad,
    required this.onEjerciciosPressed,
    required this.onEmergenciaPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnsiedadButtons(
      puntajeAnsiedad: puntajeAnsiedad,
      onEjerciciosPressed: onEjerciciosPressed,
      onEmergenciaPressed: onEmergenciaPressed,
    );
  }
}