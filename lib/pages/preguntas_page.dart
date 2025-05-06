import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import '../appwrite/results_service.dart';
import 'resultados_page.dart';
import '../services/preguntas_ia_service.dart';

class PreguntasPage extends StatefulWidget {
  final Client client;
  final String userId;

  const PreguntasPage({super.key, required this.client, required this.userId});

  @override
  State<PreguntasPage> createState() => _PreguntasPageState();
}

class _PreguntasPageState extends State<PreguntasPage> {
  List<String> _preguntas = [];
  List<int> _respuestas = [];
  int _preguntaActual = 0;
  late final ResultsService _resultsService;
  final PreguntasIAService _iaService = PreguntasIAService();
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _resultsService = ResultsService(client: widget.client);
    _cargarPreguntasIA();
  }

  Future<void> _cargarPreguntasIA() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final preguntasGeneradas = await _iaService.generarPreguntas();
      setState(() {
        _preguntas = preguntasGeneradas;
        _respuestas = List.filled(_preguntas.length, 0);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error al cargar las preguntas: $e';
        _isLoading = false;
      });
    }
  }

  void _responderPregunta(int nivel) {
    setState(() {
      _respuestas[_preguntaActual] = nivel;
    });
  }

  void _siguientePregunta() {
    if (_preguntaActual < _preguntas.length - 1) {
      setState(() {
        _preguntaActual++;
      });
    }
  }

  void _anteriorPregunta() {
    if (_preguntaActual > 0) {
      setState(() {
        _preguntaActual--;
      });
    }
  }

  int _calcularPuntuacionTotal() {
  return _respuestas.reduce((a, b) => a + b);
}

  void _guardarYVerResultados() async {
    int puntuacionTotal = _calcularPuntuacionTotal();
    try {
      await _resultsService.guardarResultado(widget.userId, puntuacionTotal);
      print('Puntuación total guardada: $puntuacionTotal para el usuario ${widget.userId}');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultadosPage(client: widget.client, userId: widget.userId),
        ),
      );
    } catch (e) {
      print('Error al guardar la puntuación: $e');
      // Mostrar un mensaje de error al usuario si es necesario
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text('Cargando Preguntas...')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(child: Text('Error al cargar las preguntas: $_errorMessage')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Cuestionario de Ansiedad')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              _preguntas[_preguntaActual],
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text('Nada'),
                ...List.generate(5, (index) => ElevatedButton(
                      onPressed: () => _responderPregunta(index + 1),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _respuestas[_preguntaActual] == index + 1 ? Colors.blue : null,
                      ),
                      child: Text('${index + 1}'),
                    )),
                const Text('Mucho'),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_preguntaActual > 0)
                  ElevatedButton(onPressed: _anteriorPregunta, child: const Text('Anterior')),
                Text('Pregunta ${_preguntaActual + 1}/${_preguntas.length}'),
                if (_preguntaActual < _preguntas.length - 1)
                  ElevatedButton(onPressed: _siguientePregunta, child: const Text('Siguiente')),
              ],
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _respuestas.every((r) => r > 0) ? _guardarYVerResultados : null,
              child: const Text('Guardar y Ver Resultados'),
            ),
          ],
        ),
      ),
    );
  }
}