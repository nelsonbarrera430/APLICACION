import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../appwrite/community_service.dart';
import '../pages/post_detail_page.dart'; // Importa la página de detalles

class PostCard extends StatefulWidget {
  final Map<String, dynamic>? post;
  final String? currentUserId;
  final CommunityService communityService;

  const PostCard({Key? key, required this.post, required this.currentUserId, required this.communityService}) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  int _likeCount = 0;
  bool _isLikedByUser = false;
  int _commentCount = 0; // Nuevo contador para comentarios

  @override
  void initState() {
    super.initState();
    _loadLikeCount();
    _checkIfLikedByUser();
    _loadCommentCount(); // Cargar el conteo inicial de comentarios
  }

  Future<void> _loadLikeCount() async {
    if (widget.post?['\$id'] != null) {
      final count = await widget.communityService.getLikesCount(widget.post!['\$id'] as String);
      setState(() {
        _likeCount = count;
      });
    }
  }

  Future<void> _loadCommentCount() async {
    if (widget.post?['\$id'] != null) {
      final count = await widget.communityService.getCommentsCount(widget.post!['\$id'] as String);
      setState(() {
        _commentCount = count;
      });
    }
  }

  Future<void> _checkIfLikedByUser() async {
    if (widget.post?['\$id'] != null && widget.currentUserId != null) {
      final liked = await widget.communityService.hasLiked(widget.currentUserId!, widget.post!['\$id'] as String);
      setState(() {
        _isLikedByUser = liked;
      });
    }
  }

  Future<void> _handleLike() async {
    if (widget.post?['\$id'] != null && widget.currentUserId != null) {
      if (_isLikedByUser) {
        await widget.communityService.removeLike(widget.currentUserId!, widget.post!['\$id'] as String);
        setState(() {
          _isLikedByUser = false;
          _likeCount--;
        });
      } else {
        await widget.communityService.giveLike(widget.currentUserId!, widget.post!['\$id'] as String);
        setState(() {
          _isLikedByUser = true;
          _likeCount++;
        });
      }
    } else {
      print('No se pudo dar/quitar like: postId o currentUserId es nulo');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.post == null) {
      return const Card(child: Padding(padding: EdgeInsets.all(8.0), child: Text('Publicación no disponible')));
    }

    final userId = widget.post!['userId'] as String? ?? 'Usuario Desconocido';
    final text = widget.post!['text'] as String? ?? '';
    final imageUrl = widget.post!['imageUrl'] as String?;
    final createdAt = widget.post!['createdAt'] as String?;
    final formattedDate = createdAt != null
        ? DateFormat('yyyy-MM-dd HH:mm').format(DateTime.parse(createdAt).toLocal())
        : 'Fecha Desconocida';
    final postId = widget.post!['\$id'] as String?;

    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Publicado por: $userId',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Text(text),
            if (imageUrl != null && imageUrl.isNotEmpty) ...[
              const SizedBox(height: 8.0),
              Image.network(
                imageUrl,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Text('Error al cargar la imagen');
                },
              ),
            ],
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Publicado el: $formattedDate', style: const TextStyle(fontSize: 12.0, color: Colors.grey)),
                Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(_isLikedByUser ? Icons.thumb_up : Icons.thumb_up_outlined),
                      onPressed: _handleLike,
                    ),
                    const SizedBox(width: 4.0),
                    Text('$_likeCount'),
                    const SizedBox(width: 8.0),
                    GestureDetector(
                      onTap: () {
                        if (postId != null) {
                          _navigateToPostDetail(context, postId);
                        }
                      },
                      child: Row(
                        children: <Widget>[
                          const Icon(Icons.comment_outlined),
                          const SizedBox(width: 4.0),
                          Text('$_commentCount'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToPostDetail(BuildContext context, String postId) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PostDetailPage(
          postId: postId,
          communityService: widget.communityService,
        ),
      ),
    );
    if (result == true) {
      // Si se devolvió true desde PostDetailPage (indicando un nuevo comentario), recargar el conteo
      _loadCommentCount();
      // También podríamos recargar la lista completa de posts si es necesario para otras actualizaciones
      // Navigator.of(context).findAncestorStateOfType<_CommunityPageState>()?._refreshPosts();
    }
  }
}