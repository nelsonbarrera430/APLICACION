import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import '../appwrite/results_service.dart';
import '../appwrite/auth_service.dart';
import '../data/ejercicios_respiracion.dart';
import '../models/ejercicio_respiracion.dart';
import 'breathing_exercises_page.dart';
import 'emergency_page.dart';
import '../widgets/resultados_appbar.dart';
import '../widgets/resultados_contenido.dart';

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
    _loadUserDataAndResults();
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
    } catch (e) {
      setState(() {
        _errorMessage = 'Error al cargar el historial de promedios diarios: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<EjercicioRespiracion> _seleccionarEjercicios(int nivelAnsiedad) {
    if (ejerciciosRespiracion.isEmpty) {
      return [];
    }

    if (nivelAnsiedad >= 7) {
      return ejerciciosRespiracion
          .where((r) => r.title.toLowerCase().contains('calmante') || r.title.toLowerCase().contains('4-7-8'))
          .take(2)
          .toList();
    } else if (nivelAnsiedad >= 4) {
      return ejerciciosRespiracion
          .where((r) => r.title.toLowerCase().contains('diafragmática') || r.title.toLowerCase().contains('contada'))
          .take(2)
          .toList();
    } else {
      return ejerciciosRespiracion
          .where((r) => r.title.toLowerCase().contains('caja') || r.title.toLowerCase().contains('fruncidos'))
          .take(2)
          .toList();
    }
  }

  void _navigateToBreathingExercises() {
    List<EjercicioRespiracion> ejerciciosRecomendados = _seleccionarEjercicios(_puntajeAnsiedad);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BreathingExercisesPage(ejercicios: ejerciciosRecomendados),
      ),
    );
  }

  void _navigateToEmergencyPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EmergencyPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ResultadosAppBar(),
      body: ResultadosContenido(
        historialPromediosDiarios: _historialPromediosDiarios,
        isLoading: _isLoading,
        errorMessage: _errorMessage,
        puntajeAnsiedad: _puntajeAnsiedad,
        onEjerciciosPressed: _navigateToBreathingExercises,
        onEmergenciaPressed: _navigateToEmergencyPage,
      ),
    );
  }
}
