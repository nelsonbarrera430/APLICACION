import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart'; // Importa directamente Document
import '../appwrite/constants.dart';

class CommunityService {
  final Client _client;
  final Databases _databases;
  final Storage _storage;

  CommunityService({required Client client})
      : _client = client,
        _databases = Databases(client),
        _storage = Storage(client);

  String get postsCollectionId => AppwriteConstants.postsCollectionId;
  String get commentsCollectionId => AppwriteConstants.commentsCollectionId;
  String get likesCollectionId => AppwriteConstants.likesCollectionId; // Agregamos esto

  Future<List<Document>> getPosts() async {
    try {
      final response = await _databases.listDocuments(
        databaseId: AppwriteConstants.databaseId,
        collectionId: postsCollectionId,
        queries: [
          Query.orderDesc('createdAt'),
        ],
      );
      return response.documents;
    } catch (e) {
      print('Error al obtener las publicaciones: $e');
      return [];
    }
  }

  Future<Document?> createPost(String userId, String text, String? imageUrl) async {
    try {
      final response = await _databases.createDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: postsCollectionId,
        documentId: ID.unique(),
        data: {
          'userId': userId,
          'text': text,
          'imageUrl': imageUrl,
          'createdAt': DateTime.now().toIso8601String(),
        },
        permissions: [
          Permission.read(Role.any()), // Todos pueden leer
          Permission.update(Role.user(userId)), // Solo el creador puede actualizar
          Permission.delete(Role.user(userId)), // Solo el creador puede eliminar
        ],
      );
      return response;
    } catch (e) {
      print('Error al crear la publicación: $e');
      return null;
    }
  }

  Future<List<Document>> getCommentsForPost(String postId) async {
    try {
      final response = await _databases.listDocuments(
        databaseId: AppwriteConstants.databaseId,
        collectionId: commentsCollectionId,
        queries: [
          Query.equal('postId', postId),
          Query.orderAsc('createdAt'),
        ],
      );
      return response.documents;
    } catch (e) {
      print('Error al obtener los comentarios de la publicación $postId: $e');
      return [];
    }
  }

  Future<int> getCommentsCount(String postId) async {
    try {
      final response = await _databases.listDocuments(
        databaseId: AppwriteConstants.databaseId,
        collectionId: commentsCollectionId,
        queries: [
          Query.equal('postId', postId),
          Query.limit(1000), // Ajusta el límite si esperas muchísimos comentarios
        ],
      );
      return response.total;
    } catch (e) {
      print('Error al obtener el conteo de comentarios para la publicación $postId: $e');
      return 0;
    }
  }

  Future<Document?> createComment(String postId, String userId, String text) async {
    try {
      final response = await _databases.createDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: commentsCollectionId,
        documentId: ID.unique(),
        data: {
          'postId': postId,
          'userId': userId,
          'text': text,
          'createdAt': DateTime.now().toIso8601String(),
        },
        permissions: [
          Permission.read(Role.any()),
          Permission.update(Role.user(userId)),
          Permission.delete(Role.user(userId)),
        ],
      );
      return response;
    } catch (e) {
      print('Error al crear el comentario en la publicación $postId: $e');
      return null;
    }
  }

  Future<Document?> giveLike(String userId, String postId) async { // Método para dar like
    try {
      final response = await _databases.createDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.likesCollectionId,
        documentId: ID.unique(),
        data: {
          'userId': userId,
          'postId': postId,
          'createdAt': DateTime.now().toIso8601String(),
        },
        permissions: [
          Permission.read(Role.any()), // Cualquiera puede leer el like (para contar)
          Permission.delete(Role.user(userId)), // Solo el creador puede eliminar su like
        ],
      );
      return response;
    } catch (e) {
      print('Error al dar like: $e');
      return null;
    }
  }

  Future<int> getLikesCount(String postId) async { // Método para obtener el conteo de likes
    try {
      final response = await _databases.listDocuments(
        databaseId: AppwriteConstants.databaseId,
        collectionId: likesCollectionId,
        queries: [
          Query.equal('postId', postId),
          Query.limit(1000), // Puedes ajustar el límite si esperas muchísimos likes
        ],
      );
      return response.total;
    } catch (e) {
      print('Error al obtener el conteo de likes para la publicación $postId: $e');
      return 0;
    }
  }

  Future<bool> hasLiked(String userId, String postId) async {
    try {
      final response = await _databases.listDocuments(
        databaseId: AppwriteConstants.databaseId,
        collectionId: likesCollectionId,
        queries: [
          Query.equal('userId', userId),
          Query.equal('postId', postId),
          Query.limit(1),
        ],
      );
      return response.total > 0;
    } catch (e) {
      print('Error al verificar si el usuario dio like: $e');
      return false;
    }
  }

  Future<void> removeLike(String userId, String postId) async {
    try {
      final response = await _databases.listDocuments(
        databaseId: AppwriteConstants.databaseId,
        collectionId: likesCollectionId,
        queries: [
          Query.equal('userId', userId),
          Query.equal('postId', postId),
          Query.limit(1),
        ],
      );
      if (response.total > 0) {
        await _databases.deleteDocument(
          databaseId: AppwriteConstants.databaseId,
          collectionId: likesCollectionId,
          documentId: response.documents.first.$id,
        );
        print('Like removido por el usuario $userId en la publicación $postId');
      }
    } catch (e) {
      print('Error al remover el like: $e');
      return null;
    }
  }

  String getFileViewUrl(String fileId) {
    return '${AppwriteConstants.endpoint}/storage/buckets/default/files/$fileId/view?project=${AppwriteConstants.projectId}';
  }
}