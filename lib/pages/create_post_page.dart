import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:appwrite/appwrite.dart';
import '../appwrite/community_service.dart';
import '../appwrite/auth_service.dart';
import '../appwrite/constants.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final TextEditingController _textController = TextEditingController();
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  late final Client _client;
  late final CommunityService _communityService;
  late final AuthService _authService;
  String? _userId;

  @override
  void initState() {
    super.initState();
    _client = Client().setEndpoint(AppwriteConstants.endpoint).setProject(AppwriteConstants.projectId);
    _communityService = CommunityService(client: _client);
    _authService = AuthService();
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    final user = await _authService.getCurrentUser();
    setState(() {
      _userId = user?.$id;
    });
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  Future<void> _createPost() async {
    if (_userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No se pudo obtener el ID del usuario.')));
      return;
    }

    final text = _textController.text.trim();
    String? imageUrl;

    if (_selectedImage != null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Subiendo imagen...')));
      imageUrl = await _communityService.uploadImage(_selectedImage!);
      if (imageUrl == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error al subir la imagen.')));
        return;
      }
      print('URL de la imagen subida: $imageUrl');
    } else if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('La publicación debe tener texto o una imagen.')));
      return;
    }

    final post = await _communityService.createPost(_userId!, text, imageUrl);
    if (post != null) {
      Navigator.pop(context); // Volver a la página de la comunidad después de crear la publicación
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error al crear la publicación.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Publicación'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: _textController,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: 'Escribe algo...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Seleccionar Imagen (Galería)'),
            ),
            if (_selectedImage != null) ...[
              const SizedBox(height: 16.0),
              Image.file(
                _selectedImage!,
                height: 200,
                fit: BoxFit.cover,
              ),
            ],
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: _createPost,
              child: const Text('Publicar'),
            ),
          ],
        ),
      ),
    );
  }
}