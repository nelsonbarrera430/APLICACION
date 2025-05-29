import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../appwrite/community_service.dart';

class PostCardRedditStyle extends StatelessWidget {
  final Map<String, dynamic> post;
  final String? currentUserId;
  final CommunityService communityService;

  const PostCardRedditStyle({
    Key? key,
    required this.post,
    required this.currentUserId,
    required this.communityService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final username = post['username'] ?? 'Anónimo';
    final content = post['content'] ?? '';
    final timestamp = post['timestamp'] != null
        ? DateTime.tryParse(post['timestamp'])
        : null;
    final formattedDate = timestamp != null
        ? DateFormat('dd MMM yyyy, hh:mm a').format(timestamp)
        : 'Fecha desconocida';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade800),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'u/$username',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  formattedDate,
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            /// Contenido del post
            Text(
              content,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 12),

            /// Acciones (sin funcionalidad aún)
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.thumb_up_alt_outlined, size: 20),
                  color: Colors.white70,
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.thumb_down_alt_outlined, size: 20),
                  color: Colors.white70,
                  onPressed: () {},
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.comment_outlined, size: 20),
                  color: Colors.white70,
                  onPressed: () {},
                ),
                const Text(
                  'Comentar',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
