import 'package:flutter/material.dart';

class HistorialAnsiedadTitulo extends StatelessWidget {
  const HistorialAnsiedadTitulo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Historial de tu Nivel de Ansiedad Diario',
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      textAlign: TextAlign.center,
    );
  }
}