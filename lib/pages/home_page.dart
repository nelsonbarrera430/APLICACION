import 'package:flutter/material.dart';
import 'login_page.dart';
import 'preguntas_page.dart';
import 'resultados_page.dart';
import 'package:appwrite/appwrite.dart';
import '../appwrite/constants.dart'; // Asegúrate de tener este import

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final Client client;
  String? userId;

  @override
  void initState() {
    super.initState();
    client = Client()
        .setEndpoint(AppwriteConstants.endpoint)
        .setProject(AppwriteConstants.projectId);
    // Aquí podrías obtener el userId si ya lo tienes disponible
    // o pasarlo desde la página anterior. Para esta prueba, lo dejaremos null.
  }

  void _logout(BuildContext context) async {
    // Simulamos un logout sin Appwrite en esta prueba
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inicio'), actions: [
        IconButton(onPressed: () => _logout(context), icon: const Icon(Icons.logout))
      ]),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Bienvenido al inicio'),
            const SizedBox(height: 20),
            // Botón para navegar a la página de preguntas (PASANDO EL CLIENT)
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PreguntasPage(client: client, userId: userId ?? '')),
                );
              },
              child: const Text('Ver preguntas de ansiedad'),
            ),
            const SizedBox(height: 20),
            // Nuevo botón para navegar a la página de resultados (PASANDO EL CLIENT)
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ResultadosPage(client: client, userId: userId ?? ''),
                  ),
                );
              },
              child: const Text('Ver Resultados'),
            ),
          ],
        ),
      ),
    );
  }
}