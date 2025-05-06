import 'package:appwrite/appwrite.dart';
import 'constants.dart';

class ResultsService {
  final Client _client;
  final String _databaseId = AppwriteConstants.databaseId;
  final String _graphicsCollectionId = AppwriteConstants.graphicsCollectionId; // Usa el ID de "graficos"

  ResultsService({required Client client}) : _client = client;

  Future<void> guardarResultado(String userId, int resultado) async {
    try {
      final databases = Databases(_client);
      await databases.createDocument(
        databaseId: _databaseId,
        collectionId: _graphicsCollectionId, // Guarda en la colección "graficos"
        documentId: ID.unique(),
        data: {
          'userId': userId,
          'fechaRegistro': DateTime.now().toIso8601String(),
          'resultado': resultado,
        },
      );
      print('Resultado guardado para el usuario: $userId en gráficos');
    } catch (e) {
      print('Error al guardar el resultado en gráficos para el usuario $userId: $e');
      throw e;
    }
  }

  Future<List<Map<String, dynamic>>> cargarHistorialResultados(String userId) async {
    try {
      final databases = Databases(_client);
      final response = await databases.listDocuments(
        databaseId: _databaseId,
        collectionId: _graphicsCollectionId, // Carga desde la colección "graficos"
        queries: [
          Query.equal('userId', userId),
          Query.orderAsc('fechaRegistro'),
        ],
      );

      return response.documents.map((doc) {
        return {
          'fechaRegistro': doc.data['fechaRegistro'],
          'resultado': doc.data['resultado'],
        };
      }).toList();
    } catch (e) {
      print('Error al cargar el historial de gráficos para el usuario $userId: $e');
      throw e;
    }
  }
}