import 'package:flutter/material.dart';
import 'login_page.dart';
import 'preguntas_page.dart';
import 'resultados_page.dart';
import 'community_page.dart';
import 'breathing_exercise_page.dart';
import 'chatbot_page.dart';
import 'ejercicio_page.dart'; // Importa la nueva página de ejercicios
import 'package:appwrite/appwrite.dart';
import '../appwrite/constants.dart';
import '../appwrite/auth_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final Client client;
  String? userId;
  late final AuthService _authService;

  @override
  void initState() {
    super.initState();
    client = Client()
      .setEndpoint(AppwriteConstants.endpoint)
      .setProject(AppwriteConstants.projectId);
    _authService = AuthService();
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    final user = await _authService.getCurrentUser();
    setState(() {
      userId = user?.$id;
    });
  }

  void _logout(BuildContext context) async {
    await _authService.logout();
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
            ElevatedButton(
              onPressed: () {
                if (userId != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PreguntasPage(client: client, userId: userId!)),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Cargando información del usuario...')),
                  );
                }
              },
              child: const Text('Realizar cuestionario de ansiedad'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ResultadosPage(client: client)),
                );
              },
              child: const Text('Ver Resultados'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CommunityPage()),
                );
              },
              child: const Text('Comunidad'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BreathingExercisePage()),
                );
              },
              child: const Text('Respiración Rápida'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ChatbotScreen()),
                );
              },
              child: const Text('CHIP - Asistente'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const EjercicioPage()), // Navegar a EjerciciosPage
                );
              },
              child: const Text('Ver Todos los Ejercicios'),
            ),
          ],
        ),
      ),
    );
  }
}
