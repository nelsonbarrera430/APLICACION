import 'package:flutter/material.dart';
import 'package:appwrite/models.dart';
import '../controllers/post_detail_controller.dart';
import '../appwrite/community_service.dart';
import '../widgets/cards/CommentCard.dart';

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
  late PostDetailController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PostDetailController(
      postId: widget.postId,
      communityService: widget.communityService,
    );
    _controller.loadCurrentUser().then((_) {
      setState(() {}); 
    });
  }

  @override
  void dispose() {
    _controller.dispose();
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
              future: _controller.commentsFuture,
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
                      controller: _controller.commentController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Escribe un comentario...',
                        hintStyle: const TextStyle(color: Colors.white54),
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
                      onPressed: () => _controller.createComment(() {
                        setState(() {});
                      }),
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
