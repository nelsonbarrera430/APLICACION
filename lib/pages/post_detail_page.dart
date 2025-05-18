import 'package:flutter/material.dart';
import 'package:appwrite/models.dart';
import '../appwrite/community_service.dart';
import '../appwrite/auth_service.dart';
import '../widgets/CommentCard.dart'; // Importa el widget

class PostDetailPage extends StatefulWidget {
  final String postId;
  final CommunityService communityService;

  const PostDetailPage({
    Key? key,
    required this.postId,
    required this.communityService,
  }) : super(key: key);

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  late Future<List<Document>> _commentsFuture;
  final TextEditingController _commentController = TextEditingController();
  final AuthService _authService = AuthService();
  String? _currentUserId;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
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
      await widget.communityService.createComment(
        widget.postId,
        _currentUserId!,
        _commentController.text,
      );
      _commentController.clear();
      setState(() {
        _commentsFuture = widget.communityService.getCommentsForPost(widget.postId);
      });
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
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 165, 30, 0),
        title: const Text('Comentarios'),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<Document>>(
              future: _commentsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Colors.deepOrange));
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error al cargar los comentarios: ${snapshot.error}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text(
                      'No hay comentarios aún. ¡Sé el primero en comentar!',
                      style: TextStyle(color: Colors.white70),
                    ),
                  );
                } else {
                  final comments = snapshot.data!;
                  return ListView.builder(
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    itemCount: comments.length,
                    itemBuilder: (context, index) {
                      final comment = comments[index].data;
                      return CommentCard(
                        userId: comment['userId'] ?? 'Unknown',
                        text: comment['text'] ?? '',
                      );
                    },
                  );
                }
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.8),
                  offset: const Offset(0, -1),
                  blurRadius: 6,
                )
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Escribe un comentario...',
                        hintStyle: TextStyle(color: Colors.white54),
                        filled: true,
                        fillColor: Colors.grey[850],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: Colors.deepOrange,
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white),
                      onPressed: _createComment,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
