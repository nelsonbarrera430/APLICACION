import 'package:flutter/material.dart';
import 'login_page.dart';
import 'preguntas_page.dart';
import 'resultados_page.dart';
import 'community_page.dart';
import 'breathing_exercise_page.dart';
import 'chatbot_page.dart';
import 'ejercicio_page.dart';
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
      ..setEndpoint(AppwriteConstants.endpoint)
      ..setProject(AppwriteConstants.projectId);
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

  void _handleCategoryTap(String category) {
    switch (category) {
      case 'Cuestionario':
        if (userId != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => PreguntasPage(client: client, userId: userId!)),
          );
        }
        break;
      case 'Resultados':
        Navigator.push(context, MaterialPageRoute(builder: (_) => ResultadosPage(client: client)));
        break;
      case 'Comunidad':
        Navigator.push(context, MaterialPageRoute(builder: (_) => const CommunityPage()));
        break;
      case 'Respiración':
        Navigator.push(context, MaterialPageRoute(builder: (_) => BreathingExercisePage()));
        break;
      case 'Asistente':
        Navigator.push(context, MaterialPageRoute(builder: (_) => const ChatbotScreen()));
        break;
      case 'Ejercicios':
        Navigator.push(context, MaterialPageRoute(builder: (_) => const EjercicioPage()));
        break;
      case 'Cerrar sesión':
        _logout(context);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text('Bienvenido', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
            Expanded(child: CategoryGrid(onCategoryTap: _handleCategoryTap)),
          ],
        ),
      ),
    );
  }
}

class CategoryGrid extends StatelessWidget {
  final void Function(String) onCategoryTap;
  const CategoryGrid({super.key, required this.onCategoryTap});

  @override
  Widget build(BuildContext context) {
    final categories = [
      {'name': 'Cuestionario', 'icon': Icons.question_answer},
      {'name': 'Resultados', 'icon': Icons.bar_chart},
      {'name': 'Comunidad', 'icon': Icons.people},
      {'name': 'Respiración', 'icon': Icons.air},
      {'name': 'Asistente', 'icon': Icons.chat},
      {'name': 'Ejercicios', 'icon': Icons.fitness_center},
      {'name': 'Cerrar sesión', 'icon': Icons.exit_to_app},
    ];

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.1,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return ElevatedButton(
          onPressed: () => onCategoryTap(category['name'] as String), // Aseguramos el tipo String
          style: ElevatedButton.styleFrom(
            backgroundColor: category['name'] == 'Cerrar sesión' ? Colors.red : Colors.blueGrey,
            foregroundColor: category['name'] == 'Cerrar sesión' ? Colors.white : null,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(category['icon'] as IconData, color: Colors.white, size: 40), // Aseguramos el tipo IconData
              Text(
                category['name'] as String, // Aseguramos el tipo String
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }
}
