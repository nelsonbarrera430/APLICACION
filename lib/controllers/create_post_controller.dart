import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:appwrite/appwrite.dart';
import '../appwrite/community_service.dart';
import '../appwrite/auth_service.dart';
import '../appwrite/constants.dart';

class CreatePostController {
  final TextEditingController textController = TextEditingController();
  File? selectedImage;
  final ImagePicker picker = ImagePicker();
  late final Client client;
  late final CommunityService communityService;
  late final AuthService authService;
  String? userId;

  CreatePostController() {
    client = Client()
      .setEndpoint(AppwriteConstants.endpoint)
      .setProject(AppwriteConstants.projectId);
    communityService = CommunityService(client: client);
    authService = AuthService();
  }

  Future<void> loadCurrentUser() async {
    final user = await authService.getCurrentUser();
    userId = user?.$id;
  }

  Future<void> pickImage() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedImage = File(image.path);
    }
  }

  Future<String?> uploadSelectedImage() async {
    if (selectedImage == null) return null;
    return await communityService.uploadImage(selectedImage!);
  }

  Future<bool> createPost() async {
    if (userId == null) return false;
    final text = textController.text.trim();
    String? imageUrl;

    if (selectedImage != null) {
      imageUrl = await uploadSelectedImage();
      if (imageUrl == null) return false;
    } else if (text.isEmpty) {
      return false;
    }

    final post = await communityService.createPost(userId!, text, imageUrl);
    return post != null;
  }

  void dispose() {
    textController.dispose();
  }
}
