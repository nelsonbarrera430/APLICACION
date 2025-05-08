import 'package:flutter/material.dart';
import '../models/ejercicio_respiracion.dart';

class BreathingExercisesPage extends StatefulWidget {
  final List<EjercicioRespiracion> ejercicios;

  const BreathingExercisesPage({Key? key, required this.ejercicios}) : super(key: key);

  @override
  _BreathingExercisesPageState createState() => _BreathingExercisesPageState();
}

class _BreathingExercisesPageState extends State<BreathingExercisesPage> {
  // Claves para las URLs de los GIFs actualizadas
  final Map<int, String> gifUrls = {};

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.ejercicios.length; i++) {
      gifUrls[i] = widget.ejercicios[i].gifUrl;
    }
  }

  // Función que modifica la URL del GIF para forzar recarga
  void _resetGif(int index) {
    setState(() {
      gifUrls[index] =
          "${widget.ejercicios[index].gifUrl}?${DateTime.now().millisecondsSinceEpoch}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ejercicios de Respiración'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: widget.ejercicios.length,
        itemBuilder: (context, index) {
          final ejercicio = widget.ejercicios[index];

          return Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ejercicio.title,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    ejercicio.description,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  Image.network(
                    gifUrls[index]!, // usamos la URL modificada
                    height: 300,
                    width: double.infinity,
                    fit: BoxFit.contain,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(child: CircularProgressIndicator());
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(child: Text('No se pudo cargar el GIF'));
                    },
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => _resetGif(index),
                    child: const Text('Ver ejemplo'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
