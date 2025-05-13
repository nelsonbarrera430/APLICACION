import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import '../appwrite/community_service.dart';
import '../widgets/post_card.dart';
import 'create_post_page.dart';
import '../appwrite/constants.dart';
import '../appwrite/auth_service.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  late final Client _client;
  late final CommunityService _communityService;
  late Future<List<Document>> _postsFuture;
  String? _currentUserId;
  final AuthService _authService = AuthService();

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
      backgroundColor: const Color(0xFF1a1a1a), // fondo negro oscuro
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        title: const Text('Comunidad', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orangeAccent,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreatePostPage()),
          );
        },
        child: const Icon(Icons.add, color: Colors.black),
      ),
      body: FutureBuilder<List<Document>>(
        future: _postsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.orangeAccent));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.white)));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay publicaciones', style: TextStyle(color: Colors.white)));
          } else {
            final posts = snapshot.data!;
            return ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index].data;
                return PostCard(
                  post: post,
                  currentUserId: _currentUserId,
                  communityService: _communityService,
                );
              },
            );
          }
        },
      ),
    );
  }
}
