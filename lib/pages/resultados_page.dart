import 'package:flutter/material.dart';
import 'package:flutter_echarts/flutter_echarts.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:appwrite/appwrite.dart';
import '../appwrite/results_service.dart';
import 'package:intl/date_symbol_data_local.dart'; // Importa para la inicialización

class ResultadosPage extends StatefulWidget {
  final Client client;
  final String userId;

  const ResultadosPage({super.key, required this.client, required this.userId});

  @override
  State<ResultadosPage> createState() => _ResultadosPageState();
}

class _ResultadosPageState extends State<ResultadosPage> {
  List<Map<String, dynamic>> _historialResultados = [];
  bool _isLoading = true;
  String? _errorMessage;
  late final ResultsService _resultsService;

  @override
  void initState() {
    super.initState();
    _resultsService = ResultsService(client: widget.client);
    // Inicializa la localización para español de Colombia
    initializeDateFormatting('es_CO', null).then((_) {
      _cargarHistorialResultados();
    });
  }

  Future<void> _cargarHistorialResultados() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      _historialResultados = await _resultsService.cargarHistorialResultados(widget.userId);
      print('Historial cargado: ${_historialResultados}');
    } catch (e) {
      setState(() {
        _errorMessage = 'Error al cargar el historial de resultados: $e';
        print('Error al cargar el historial: $e');
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _generarOpcionesECharts() {
    if (_historialResultados.isEmpty) {
      return jsonEncode({
        'xAxis': {'type': 'category', 'data': []},
        'yAxis': {'type': 'value'},
        'series': [],
        'title': {'text': 'Aún no hay resultados registrados'},
      });
    }

    final xAxisData = _historialResultados.map((data) {
      return DateFormat('EEE d', 'es_CO').format(DateTime.parse(data['fechaRegistro']));
    }).toList();

    final seriesData = _historialResultados.map((data) => data['resultado']).toList();

    final options = {
      'xAxis': {'type': 'category', 'data': xAxisData, 'name': 'Fecha'},
      'yAxis': {'type': 'value', 'name': 'Resultado'},
      'series': [
        {
          'name': 'Resultado',
          'type': 'line',
          'data': seriesData,
          'itemStyle': {'color': '#007BFF'},
          'lineStyle': {'width': 2},
          'label': {'show': true, 'position': 'top'},
        },
      ],
      'tooltip': {'trigger': 'axis'},
      'grid': {'left': '10%', 'right': '5%', 'bottom': '15%', 'containLabel': true},
    };
    print('Opciones ECharts generadas: ${jsonEncode(options)}');
    return jsonEncode(options);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de Resultados'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Text(
              'Tu Historial de Resultados',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _errorMessage != null
                      ? Center(child: Text(_errorMessage!))
                      : _historialResultados.isNotEmpty
                          ? Echarts(
                              option: _generarOpcionesECharts(),
                            )
                          : const Center(child: Text('No hay resultados para mostrar.')),
            ),
            const SizedBox(height: 20),
            const Text(
              'Tus resultados a lo largo del tiempo',
              textAlign: TextAlign.center,
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }
}