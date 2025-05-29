import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import '../appwrite/results_service.dart';
import 'resultados_page.dart';
import '../services/preguntas_ia_service.dart';
import 'package:intl/intl.dart';
import '../widgets/questionnaires/pregunta_card.dart';
import '../widgets/questionnaires/cuestionario_botones.dart';
import '../widgets/questionnaires/cuestionario_cargando.dart';
import '../widgets/questionnaires/cuestionario_completado_hoy.dart';

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
    _yaCompletoHoyFuture =
        _resultsService.yaCompletoCuestionarioHoy(widget.userId);
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
        print('Error: Promedio inválido ($promedioDiario). No se guardarán los resultados.');
        return;
      }

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

  void _irAPreguntaAnterior() {
    setState(() {
      _preguntaActualIndex--;
      _respuestaActual = _respuestas[_preguntaActualIndex]!.toDouble();
      _respuestas.removeLast();
    });
  }

  Widget _construirPantalla() {
    return Scaffold(
      
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<bool>(
          future: _yaCompletoHoyFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CuestionarioCargando();
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.data == true) {
              return const CuestionarioCompletadoHoy();
            } else {
              return FutureBuilder<List<String>>(
                future: _preguntasFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CuestionarioCargando();
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No se generaron preguntas.'));
                  } else {
                    _preguntas = snapshot.data!;
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Expanded(
                          child: PreguntaCard(
                            pregunta: _preguntas[_preguntaActualIndex],
                            respuestaActual: _respuestaActual,
                            onRespuestaChanged: (value) {
                              setState(() {
                                _respuestaActual = value;
                              });
                            },
                          ),
                        ),
                        CuestionarioBotones(
                          preguntaActualIndex: _preguntaActualIndex,
                          totalPreguntas: _preguntas.length,
                          onSiguientePressed: _responderPregunta,
                          onAnteriorPressed: _preguntaActualIndex > 0
                              ? _irAPreguntaAnterior
                              : null,
                        ),
                      ],
                    );
                  }
                },
              );
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => _construirPantalla();
}
