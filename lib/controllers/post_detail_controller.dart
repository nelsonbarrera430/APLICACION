import 'package:flutter/material.dart';
import 'package:appwrite/models.dart';
import '../appwrite/auth_service.dart';
import '../appwrite/community_service.dart';

class PostDetailController {
  final String postId;
  final CommunityService communityService;
  final TextEditingController commentController = TextEditingController();
  final AuthService _authService = AuthService();

  String? currentUserId;
  late Future<List<Document>> commentsFuture;

  PostDetailController({
    required this.postId,
    required this.communityService,
  }) {
    commentsFuture = communityService.getCommentsForPost(postId);
  }

  Future<void> loadCurrentUser() async {
    final user = await _authService.getCurrentUser();
    currentUserId = user?.$id;
  }

  Future<void> createComment(VoidCallback onRefresh) async {
    if (currentUserId != null && commentController.text.isNotEmpty) {
      await communityService.createComment(
        postId,
        currentUserId!,
        commentController.text,
      );
      commentController.clear();
      commentsFuture = communityService.getCommentsForPost(postId);
      onRefresh(); // Notifica al UI que actualice
    }
  }

  void dispose() {
    commentController.dispose();
  }
}
