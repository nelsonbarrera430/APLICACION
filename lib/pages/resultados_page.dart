import 'package:flutter/material.dart';
import 'package:flutter_echarts/flutter_echarts.dart';
import 'dart:convert';
import 'package:appwrite/appwrite.dart';
import '../appwrite/results_service.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../appwrite/auth_service.dart';
import '../data/ejercicios_respiracion.dart'; // Importa los datos de respiración
import '../models/ejercicio_respiracion.dart'; // Importa el modelo
import 'breathing_exercises_page.dart'; // Importa la nueva página

class ResultadosPage extends StatefulWidget {
  final Client client;

  const ResultadosPage({Key? key, required this.client}) : super(key: key);

  @override
  _ResultadosPageState createState() => _ResultadosPageState();
}

class _ResultadosPageState extends State<ResultadosPage> {
  List<Map<String, dynamic>> _historialPromediosDiarios = [];
  bool _isLoading = true;
  String? _errorMessage;
  late final ResultsService _resultsService;
  late final AuthService _authService;
  String? _userId;
  int _puntajeAnsiedad = 0;

  @override
  void initState() {
    super.initState();
    _resultsService = ResultsService(client: widget.client);
    _authService = AuthService();
    initializeDateFormatting('es_CO', null).then((_) {
      _loadUserDataAndResults();
    });
  }

  Future<void> _loadUserDataAndResults() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final user = await _authService.getCurrentUser();
      if (user == null) {
        setState(() {
          _errorMessage = 'No hay usuario logueado.';
          _isLoading = false;
        });
        return;
      }
      _userId = user.$id;
      final historial = await _resultsService.cargarHistorialResultados(_userId!);
      _historialPromediosDiarios = historial;

      if (historial.isNotEmpty) {
        double suma = 0;
        for (var resultado in historial) {
          suma += (resultado['promedio'] as num).toDouble();
        }
        _puntajeAnsiedad = (suma / historial.length).round();
      } else {
        _puntajeAnsiedad = 0;
      }

      print('Historial de promedios diarios cargado para el usuario $_userId: $_historialPromediosDiarios');
      print('Puntaje de ansiedad promedio: $_puntajeAnsiedad'); // Imprime el puntaje de ansiedad
    } catch (e) {
      setState(() {
        _errorMessage = 'Error al cargar el historial de promedios diarios: $e';
        print('Error al cargar el historial de promedios diarios: $e');
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _generarOpcionesECharts() {
    if (_isLoading) {
      return jsonEncode({
        'title': {'text': 'Cargando datos...'},
        'series': [],
      });
    }
    if (_errorMessage != null) {
      return jsonEncode({
        'title': {'text': 'Error al cargar los datos'},
        'series': [],
      });
    }
    if (_historialPromediosDiarios.isEmpty) {
      return jsonEncode({
        'xAxis': {'type': 'category', 'data': []},
        'yAxis': {'type': 'value', 'min': 1, 'max': 10},
        'series': [],
        'title': {'text': 'No hay datos de ansiedad registrados aún'},
      });
    }
    final xAxisData = _historialPromediosDiarios.map((data) {
      return data['diaSemana'] == null ? 'Sin Día' : data['diaSemana'] as String;
    }).toList();
    final seriesData = _historialPromediosDiarios.map((data) => (data['promedio'] as num?)?.toDouble().toStringAsFixed(2) ?? '0').toList();
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
    print('Opciones ECharts (historial diario) para el usuario $_userId: ${jsonEncode(options)}');
    return jsonEncode(options);
  }

  List<EjercicioRespiracion> _seleccionarEjercicios(int nivelAnsiedad) {
    if (ejerciciosRespiracion.isEmpty) {
      return [];
    }

    if (nivelAnsiedad >= 7) {
      return ejerciciosRespiracion.where((r) =>
          r.title.toLowerCase().contains('calmante') ||
          r.title.toLowerCase().contains('4-7-8')).take(2).toList();
    } else if (nivelAnsiedad >= 4) {
      return ejerciciosRespiracion.where((r) =>
          r.title.toLowerCase().contains('diafragmática') ||
          r.title.toLowerCase().contains('contada')).take(2).toList();
    } else {
      return ejerciciosRespiracion.where((r) =>
          r.title.toLowerCase().contains('caja') ||
          r.title.toLowerCase().contains('fruncidos')).take(2).toList();
    }
  }

  void _navigateToBreathingExercises() {
    List<EjercicioRespiracion> ejerciciosRecomendados = _seleccionarEjercicios(_puntajeAnsiedad);
    print('Ejercicios recomendados: $ejerciciosRecomendados'); // Verifica qué ejercicios se seleccionan
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BreathingExercisesPage(ejercicios: ejerciciosRecomendados),
      ),
    );
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
              'Historial de tu Nivel de Ansiedad Diario',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _errorMessage != null
                      ? Center(child: Text(_errorMessage!))
                      : Echarts(
                          option: _generarOpcionesECharts(),
                        ),
            ),
            const SizedBox(height: 20),
            Text(
              'Tu puntaje de ansiedad promedio es: $_puntajeAnsiedad',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            const Text(
              'Este gráfico muestra el promedio de tu nivel de ansiedad para cada día que completaste el cuestionario.',
              style: TextStyle(fontStyle: FontStyle.italic),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _navigateToBreathingExercises,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade400,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: const Text(
                'Ejercicios para calmarte',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}