import 'package:flutter/material.dart';
import 'dart:convert';

class AnsiedadChartOptions {
  final List<Map<String, dynamic>> historialPromediosDiarios;
  final bool isLoading;
  final String? errorMessage;

  const AnsiedadChartOptions({
    required this.historialPromediosDiarios,
    required this.isLoading,
    this.errorMessage,
  });

  String generarOpcionesECharts() {
    if (isLoading) {
      return jsonEncode({
        'title': {'text': 'Cargando datos...'},
        'series': [],
      });
    }
    if (errorMessage != null) {
      return jsonEncode({
        'title': {'text': 'Error al cargar los datos'},
        'series': [],
      });
    }
    if (historialPromediosDiarios.isEmpty) {
      return jsonEncode({
        'xAxis': {'type': 'category', 'data': []},
        'yAxis': {'type': 'value', 'min': 1, 'max': 10},
        'series': [],
        'title': {'text': 'No hay datos de ansiedad registrados aún'},
      });
    }

    final xAxisData = historialPromediosDiarios.map((data) {
      return data['diaSemana'] ?? 'Sin Día';
    }).toList();

    final seriesData = historialPromediosDiarios
        .map((data) => (data['promedio'] as num?)?.toDouble().toStringAsFixed(2) ?? '0')
        .toList();

    final options = {
      'xAxis': {'type': 'category', 'data': xAxisData, 'name': 'Día'},
      'yAxis': {'type': 'value', 'name': 'Promedio de Ansiedad (1-10)', 'min': 1, 'max': 10},
      'series': [
        {
          'name': 'Promedio Diario',
          'type': 'bar',
          'data': seriesData,
          'itemStyle': {'color': '#007BFF'},
          'label': {'show': true, 'position': 'top'},
        },
      ],
      'tooltip': {'trigger': 'axis'},
      'grid': {'left': '10%', 'right': '5%', 'bottom': '15%', 'containLabel': true},
      'title': {'text': 'Historial de Ansiedad Diario'},
    };

    return jsonEncode(options);
  }
}