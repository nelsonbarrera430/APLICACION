import 'package:flutter/material.dart';
import '../data/ejercicios_respiracion.dart'; // Asegúrate de que la ruta sea correcta
import '../models/ejercicio_respiracion.dart'; // Asegúrate de que la ruta sea correcta

class EjercicioPage extends StatefulWidget {
  const EjercicioPage({super.key});

  @override
  _EjercicioPageState createState() => _EjercicioPageState();
}

class _EjercicioPageState extends State<EjercicioPage> {
  // Mantenemos un map de claves únicas para cada gif
  final Map<int, Key> gifKeys = {};

  // Función para actualizar la URL del GIF y forzar su recarga
  void _resetGif(int index) {
    setState(() {
      // Modificamos la URL añadiendo un parámetro de tiempo para forzar la recarga
      ejerciciosRespiracion[index].gifUrl = "${ejerciciosRespiracion[index].gifUrl}?${DateTime.now().millisecondsSinceEpoch}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ejercicios de Respiración'),
      ),
      body: SingleChildScrollView(  // Usamos SingleChildScrollView para permitir el deslizamiento
        child: Column(
          children: List.generate(ejerciciosRespiracion.length, (index) {
            final ejercicio = ejerciciosRespiracion[index];

            return Card(
              margin: const EdgeInsets.all(10),
              child: Column(  // Usamos una columna para organizar los elementos
                children: [
                  // Colocamos el GIF arriba, aumentando el tamaño
                  Image.network(
                    ejercicio.gifUrl,  // Aquí usamos la URL modificada
                    width: MediaQuery.of(context).size.width - 20, // Ajustamos el tamaño para que se vea más grande
                    height: 300,  // Ajustamos la altura para que el GIF sea más grande
                    fit: BoxFit.contain,  // Aseguramos que el GIF se ajuste sin recortarse
                  ),
                  const SizedBox(height: 10),  // Espaciado entre el GIF y el botón
                  ListTile(
                    contentPadding: const EdgeInsets.all(10),
                    title: Text(
                      ejercicio.title,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(ejercicio.description),
                  ),
                  const SizedBox(height: 10),  // Espaciado entre la descripción y el botón
                  ElevatedButton(
                    onPressed: () => _resetGif(index), // Reinicia el GIF
                    child: const Text('Ver ejemplo'),
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
