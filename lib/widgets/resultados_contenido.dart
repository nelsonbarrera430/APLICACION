import 'package:flutter/material.dart';
import '../widgets/historial_ansiedad_titulo.dart';
import '../widgets/ansiedad_chart.dart';
import '../widgets/ansiedad_chart_options.dart';
import '../widgets/ansiedad_info.dart';
import '../widgets/historial_ansiedad_acciones.dart';

class ResultadosContenido extends StatelessWidget {
  final List<Map<String, dynamic>> historialPromediosDiarios;
  final bool isLoading;
  final String? errorMessage;
  final int puntajeAnsiedad;
  final VoidCallback onEjerciciosPressed;
  final VoidCallback onEmergenciaPressed;

  const ResultadosContenido({
    Key? key,
    required this.historialPromediosDiarios,
    required this.isLoading,
    this.errorMessage,
    required this.puntajeAnsiedad,
    required this.onEjerciciosPressed,
    required this.onEmergenciaPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final chartOptionsGenerator = AnsiedadChartOptions(
      historialPromediosDiarios: historialPromediosDiarios,
      isLoading: isLoading,
      errorMessage: errorMessage,
    );
    final chartOptions = chartOptionsGenerator.generarOpcionesECharts();

    return Container(
      color: Colors.black, // Fondo negro
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const HistorialAnsiedadTitulo(),
          const SizedBox(height: 20),
          const SizedBox(height: 20), // Este empuja el gráfico un poco hacia abajo
          Expanded(
            child: Center(
              child: AnsiedadChart(
                chartOptions: chartOptions,
                isLoading: isLoading,
                errorMessage: errorMessage,
              ),
            ),
          ),
          const SizedBox(height: 20),
          AnsiedadInfo(puntajeAnsiedad: puntajeAnsiedad),
          const SizedBox(height: 30),
          HistorialAnsiedadAcciones(
            puntajeAnsiedad: puntajeAnsiedad,
            onEjerciciosPressed: onEjerciciosPressed,
            onEmergenciaPressed: onEmergenciaPressed,
          ),
        ],
      ),
    );
  }
}
