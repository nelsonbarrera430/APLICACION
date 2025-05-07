import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart'; // Importa directamente Document
import '../appwrite/community_service.dart';
import '../widgets/post_card.dart';
import 'create_post_page.dart';
import '../appwrite/constants.dart';
import '../appwrite/auth_service.dart'; // Importa AuthService

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  late final Client _client;
  late final CommunityService _communityService;
  late Future<List<Document>> _postsFuture;
  String? _currentUserId; // Para almacenar el ID del usuario actual
  final AuthService _authService = AuthService(); // Instancia de AuthService

  @override
  void initState() {
    super.initState();
    _client = Client().setEndpoint(AppwriteConstants.endpoint).setProject(AppwriteConstants.projectId);
    _communityService = CommunityService(client: _client);
    _loadCurrentUser();
    _postsFuture = _communityService.getPosts();
  }

  Future<void> _loadCurrentUser() async {
    final user = await _authService.getCurrentUser();
    setState(() {
      _currentUserId = user?.$id;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comunidad'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreatePostPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<Document>>(
        future: _postsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error al cargar las publicaciones: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay publicaciones aún. ¡Sé el primero en crear una!'));
          } else {
            final posts = snapshot.data!;
            return ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index].data;
                return PostCard(
                  post: post,
                  currentUserId: _currentUserId, // Pasamos el ID del usuario
                  communityService: _communityService, // Pasamos la instancia del servicio
                );
              },
            );
          }
        },
      ),
    );
  }
}