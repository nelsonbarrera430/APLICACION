import 'package:flutter/material.dart';
import '../data/ejercicios_respiracion.dart';

class EjercicioPage extends StatefulWidget {
  const EjercicioPage({super.key});

  @override
  _EjercicioPageState createState() => _EjercicioPageState();
}

class _EjercicioPageState extends State<EjercicioPage> {
  void _resetGif(int index) {
    setState(() {
      ejerciciosRespiracion[index].gifUrl =
          "${ejerciciosRespiracion[index].gifUrl}?${DateTime.now().millisecondsSinceEpoch}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          'Ejercicios de Respiración',
          style: TextStyle(
            color: Color(0xFFFF6347), // Rojo tomate
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: List.generate(ejerciciosRespiracion.length, (index) {
            final ejercicio = ejerciciosRespiracion[index];

            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF1C1C1C),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFFF6347), width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    child: Image.network(
                      ejercicio.gifUrl,
                      height: 220,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const SizedBox(
                          height: 220,
                          child: Center(child: CircularProgressIndicator(color: Color(0xFFFF6347))),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ejercicio.title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          ejercicio.description,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Center(
                          child: ElevatedButton(
                            onPressed: () => _resetGif(index),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFF6347),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: const Text('Ver ejemplo'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
