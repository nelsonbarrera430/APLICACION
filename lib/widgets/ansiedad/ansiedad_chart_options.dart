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
        'title': {'text': 'Cargando datos...', 'textStyle': {'color': '#ffffff'}},
        'backgroundColor': '#000000',
        'series': [],
      });
    }
    if (errorMessage != null) {
      return jsonEncode({
        'title': {'text': 'Error al cargar los datos', 'textStyle': {'color': '#ffffff'}},
        'backgroundColor': '#000000',
        'series': [],
      });
    }
    if (historialPromediosDiarios.isEmpty) {
      return jsonEncode({
        'xAxis': {'type': 'category', 'data': [], 'axisLabel': {'color': '#ffffff'}},
        'yAxis': {'type': 'value', 'min': 1, 'max': 10, 'axisLabel': {'color': '#ffffff'}},
        'series': [],
        'backgroundColor': '#000000',
        'title': {
          'text': 'No hay datos de ansiedad registrados aún',
          'textStyle': {'color': '#ffffff'}
        },
      });
    }

    final xAxisData = historialPromediosDiarios.map((data) {
      return data['diaSemana'] ?? 'Sin Día';
    }).toList();

    final seriesData = historialPromediosDiarios
        .map((data) => (data['promedio'] as num?)?.toDouble().toStringAsFixed(2) ?? '0')
        .toList();

    final options = {
      'backgroundColor': '#000000',
      'xAxis': {
        'type': 'category',
        'data': xAxisData,
        'name': 'Día',
        'axisLabel': {'color': '#ffffff'},
        'nameTextStyle': {'color': '#ffffff'},
      },
      'yAxis': {
        'type': 'value',
        'name': 'Promedio de Ansiedad (1-10)',
        'min': 1,
        'max': 10,
        'axisLabel': {'color': '#ffffff'},
        'nameTextStyle': {'color': '#ffffff'},
      },
      'series': [
        {
          'name': 'Promedio Diario',
          'type': 'bar',
          'data': seriesData,
          'itemStyle': {'color': '#B22222'},
          'label': {'show': true, 'position': 'top', 'color': '#ffffff'},
        },
      ],
      'tooltip': {'trigger': 'axis'},
      'grid': {
        'top': '120',  // MÁS ABAJO
        'left': '10%',
        'right': '5%',
        'bottom': '20%',
        'containLabel': true,
      },
      'title': {
        'text': 'Historial de Ansiedad Diario',
        'textStyle': {'color': '#ffffff', 'fontSize': 18}
      },
    };

    return jsonEncode(options);
  }
}
