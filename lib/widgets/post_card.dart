import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../appwrite/community_service.dart';
import '../pages/post_detail_page.dart';

class PostCard extends StatefulWidget {
  final Map<String, dynamic>? post;
  final String? currentUserId;
  final CommunityService communityService;

  const PostCard({
    Key? key,
    required this.post,
    required this.currentUserId,
    required this.communityService,
  }) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  int _likeCount = 0;
  bool _isLikedByUser = false;
  int _commentCount = 0;

  @override
  void initState() {
    super.initState();
    _loadLikeCount();
    _checkIfLikedByUser();
    _loadCommentCount();
  }

  Future<void> _loadLikeCount() async {
    if (widget.post?['\$id'] != null) {
      final count = await widget.communityService.getLikesCount(widget.post!['\$id']);
      setState(() {
        _likeCount = count;
      });
    }
  }

  Future<void> _loadCommentCount() async {
    if (widget.post?['\$id'] != null) {
      final count = await widget.communityService.getCommentsCount(widget.post!['\$id']);
      setState(() {
        _commentCount = count;
      });
    }
  }

  Future<void> _checkIfLikedByUser() async {
    if (widget.post?['\$id'] != null && widget.currentUserId != null) {
      final liked = await widget.communityService.hasLiked(widget.currentUserId!, widget.post!['\$id']);
      setState(() {
        _isLikedByUser = liked;
      });
    }
  }

  Future<void> _handleLike() async {
    if (widget.post?['\$id'] != null && widget.currentUserId != null) {
      if (_isLikedByUser) {
        await widget.communityService.removeLike(widget.currentUserId!, widget.post!['\$id']);
        setState(() {
          _isLikedByUser = false;
          _likeCount--;
        });
      } else {
        await widget.communityService.giveLike(widget.currentUserId!, widget.post!['\$id']);
        setState(() {
          _isLikedByUser = true;
          _likeCount++;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.post == null) {
      return const Card(color: Color(0xFF2A2A2A), child: Padding(padding: EdgeInsets.all(8.0), child: Text('Post no disponible', style: TextStyle(color: Colors.white))));
    }

    final userId = widget.post!['userId'] ?? 'Usuario';
    final text = widget.post!['text'] ?? '';
    final imageUrl = widget.post!['imageUrl'];
    final createdAt = widget.post!['createdAt'];
    final formattedDate = createdAt != null
        ? DateFormat('yyyy-MM-dd HH:mm').format(DateTime.parse(createdAt).toLocal())
        : 'Desconocido';
    final postId = widget.post!['\$id'];

    return Card(
      color: const Color(0xFF2A2A2A),
      elevation: 2.0,
      margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('u/$userId', style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6.0),
            Text(text, style: const TextStyle(color: Colors.white, fontSize: 15)),
            if (imageUrl != null && imageUrl.isNotEmpty) ...[
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    print('Error al cargar la imagen desde URL: $imageUrl - Error: $error'); // Imprime el error
                    return const Text('Error al cargar imagen', style: TextStyle(color: Colors.redAccent));
                  },
                ),
              ),
            ],
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(formattedDate, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(_isLikedByUser ? Icons.thumb_up : Icons.thumb_up_outlined, color: Colors.orangeAccent),
                      onPressed: _handleLike,
                    ),
                    Text('$_likeCount', style: const TextStyle(color: Colors.white)),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        if (postId != null) {
                          _navigateToPostDetail(context, postId);
                        }
                      },
                      child: Row(
                        children: [
                          const Icon(Icons.comment_outlined, color: Colors.orangeAccent),
                          const SizedBox(width: 4),
                          Text('$_commentCount', style: const TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  ],
                )
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
      _loadCommentCount();
    }
  }
}