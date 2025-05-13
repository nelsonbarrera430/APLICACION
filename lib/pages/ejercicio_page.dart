import 'package:flutter/material.dart';
import '../data/ejercicios_respiracion.dart'; 

class EjercicioPage extends StatefulWidget {
  const EjercicioPage({super.key});

  @override
  _EjercicioPageState createState() => _EjercicioPageState();
}

class _EjercicioPageState extends State<EjercicioPage> {
  
  final Map<int, Key> gifKeys = {};

  
  void _resetGif(int index) {
    setState(() {
      
      ejerciciosRespiracion[index].gifUrl = "${ejerciciosRespiracion[index].gifUrl}?${DateTime.now().millisecondsSinceEpoch}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ejercicios de Respiración'),
      ),
      body: SingleChildScrollView(  
        child: Column(
          children: List.generate(ejerciciosRespiracion.length, (index) {
            final ejercicio = ejerciciosRespiracion[index];

            return Card(
              margin: const EdgeInsets.all(10),
              child: Column(  
                children: [
                  
                  Image.network(
                    ejercicio.gifUrl,  
                    width: MediaQuery.of(context).size.width - 20, 
                    height: 300,  
                    fit: BoxFit.contain,  
                  ),
                  const SizedBox(height: 10),  
                  ListTile(
                    contentPadding: const EdgeInsets.all(10),
                    title: Text(
                      ejercicio.title,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(ejercicio.description),
                  ),
                  const SizedBox(height: 10),  
                  ElevatedButton(
                    onPressed: () => _resetGif(index), 
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
