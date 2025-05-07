import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import '../appwrite/results_service.dart';
import 'resultados_page.dart';
import '../services/preguntas_ia_service.dart';
import 'package:intl/intl.dart';

class PreguntasPage extends StatefulWidget {
  final Client client;
  final String userId;

  const PreguntasPage({Key? key, required this.client, required this.userId})
      : super(key: key);

  @override
  _PreguntasPageState createState() => _PreguntasPageState();
}

class _PreguntasPageState extends State<PreguntasPage> {
  late Future<List<String>> _preguntasFuture;
  List<String> _preguntas = [];
  List<int?> _respuestas = [];
  int _preguntaActualIndex = 0;
  double _respuestaActual = 5;
  late final ResultsService _resultsService;
  Future<bool>? _yaCompletoHoyFuture;

  @override
  void initState() {
    super.initState();
    _resultsService = ResultsService(client: widget.client);
    _preguntasFuture = PreguntasIAService().generarPreguntas();
    _yaCompletoHoyFuture = _resultsService.yaCompletoCuestionarioHoy(widget.userId);
  }

  int _calcularPuntuacionTotal() {
    return _respuestas.where((r) => r != null).fold(0, (sum, item) => sum + item!);
  }

  void _responderPregunta() {
    _respuestas.add(_respuestaActual.toInt());
    if (_preguntaActualIndex < _preguntas.length - 1) {
      setState(() {
        _preguntaActualIndex++;
        _respuestaActual = 5;
      });
    } else {
      final puntuacionTotal = _calcularPuntuacionTotal();
      final promedioDiario = _respuestas.isNotEmpty
          ? puntuacionTotal / _respuestas.length.toDouble()
          : 0.0;

      if (promedioDiario.isNaN || promedioDiario.isInfinite) {
        print(
            'Error: Promedio inválido ($promedioDiario). No se guardarán los resultados.');
        return;
      }

      print('Valor de promedioDiario antes de guardar: $promedioDiario');

      final now = DateTime.now();
      final diaSemana = DateFormat('EEEE', 'es_CO').format(now);
      final fechaRegistro = now.toIso8601String();

      _resultsService
          .guardarPromedioDiario(
              widget.userId, diaSemana, promedioDiario, fechaRegistro)
          .then((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ResultadosPage(client: widget.client),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preguntas de Ansiedad'),
      ),
      body: FutureBuilder<bool>(
        future: _yaCompletoHoyFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.data == true) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  'Ya has completado el cuestionario de ansiedad hoy. ¡Vuelve mañana!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            );
          } else {
            return FutureBuilder<List<String>>(
              future: _preguntasFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No se generaron preguntas.'));
                } else {
                  _preguntas = snapshot.data!;
                  if (_preguntas.isNotEmpty) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Pregunta ${_preguntaActualIndex + 1}: ${_preguntas[_preguntaActualIndex]}',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          Slider(
                            value: _respuestaActual,
                            min: 1,
                            max: 10,
                            divisions: 9,
                            label: _respuestaActual.round().toString(),
                            onChanged: (double value) {
                              setState(() {
                                _respuestaActual = value;
                              });
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const <Widget>[
                                Text('1 (Nada)'),
                                Text('10 (Mucho)'),
                              ],
                            ),
                          ),
                          const SizedBox(height: 30),
                          ElevatedButton(
                            onPressed: _responderPregunta,
                            child: Text(
                              _preguntaActualIndex < _preguntas.length - 1 ? 'Siguiente Pregunta' : 'Ver Resultados',
                            ),
                          ),
                          if (_preguntaActualIndex > 0)
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _preguntaActualIndex--;
                                  _respuestaActual = _respuestas[_preguntaActualIndex]!.toDouble() ?? 5;
                                  _respuestas.removeLast();
                                });
                              },
                              child: const Text('Anterior'),
                            ),
                        ],
                      ),
                    );
                  } else {
                    return const Center(child: Text('No hay preguntas para mostrar.'));
                  }
                }
              },
            );
          }
        },
      ),
    );
  }
}

