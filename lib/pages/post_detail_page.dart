import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import '../appwrite/community_service.dart';
import '../appwrite/auth_service.dart'; // Importa AuthService

class PostDetailPage extends StatefulWidget {
  final String postId;
  final CommunityService communityService;

  const PostDetailPage({Key? key, required this.postId, required this.communityService}) : super(key: key);

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  late Future<List<Document>> _commentsFuture;
  final TextEditingController _commentController = TextEditingController();
  final AuthService _authService = AuthService(); // Instancia de AuthService
  String? _currentUserId; // Para almacenar el ID del usuario actual

  @override
  void initState() {
    super.initState();
    _loadCurrentUser(); // Cargar el usuario actual
    _commentsFuture = widget.communityService.getCommentsForPost(widget.postId);
  }

  Future<void> _loadCurrentUser() async {
    final user = await _authService.getCurrentUser();
    setState(() {
      _currentUserId = user?.$id;
    });
  }

  Future<void> _createComment() async {
    if (_currentUserId != null && _commentController.text.isNotEmpty) {
      await widget.communityService.createComment(widget.postId, _currentUserId!, _commentController.text);
      _commentController.clear(); // Limpiar el campo de texto
      // Recargar los comentarios para mostrar el nuevo
      setState(() {
        _commentsFuture = widget.communityService.getCommentsForPost(widget.postId);
      });
      // Informar a la PostCard que hubo un nuevo comentario
      if (mounted && Navigator.of(context).canPop()) {
        Navigator.of(context).pop(true); // Devolver true para indicar que hubo un cambio
      }
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles de la Publicación'),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<Document>>(
              future: _commentsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error al cargar los comentarios: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No hay comentarios aún. ¡Sé el primero en comentar!'));
                } else {
                  final comments = snapshot.data!;
                  return ListView.builder(
                    itemCount: comments.length,
                    itemBuilder: (context, index) {
                      final comment = comments[index].data;
                      return ListTile(
                        title: Text(comment['text'] as String? ?? ''),
                        subtitle: Text('Usuario: ${comment['userId'] as String? ?? ''}'),
                      );
                    },
                  );
                }
              },
            ),
          ),
          // Sección para crear nuevos comentarios
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: const InputDecoration(
                      hintText: 'Escribe un comentario...',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _createComment,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}