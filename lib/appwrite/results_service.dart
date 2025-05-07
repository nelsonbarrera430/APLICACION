import 'package:appwrite/appwrite.dart';
import 'constants.dart';

class ResultsService {
  final Client _client;
  final String _databaseId = AppwriteConstants.databaseId;
  final String _graphicsCollectionId = AppwriteConstants.graphicsCollectionId;

  ResultsService({required Client client}) : _client = client;

  Future<void> guardarPromedioDiario(String userId, String diaSemana, double promedio, String fechaRegistro) async {
    try {
      final databases = Databases(_client);
      await databases.createDocument(
        databaseId: _databaseId,
        collectionId: _graphicsCollectionId,
        documentId: ID.unique(),
        data: {
          'userId': userId,
          'fechaRegistro': fechaRegistro,
          'diaSemana': diaSemana,
          'promedio': promedio.toInt(),
          'resultado': promedio.toInt(),
        },
      );
      print('Promedio diario guardado para el usuario: $userId en gráficos para el día: $diaSemana con promedio: $promedio');
    } catch (e) {
      print('Error al guardar el promedio diario en gráficos para el usuario $userId: $e');
      throw e;
    }
  }

  Future<List<Map<String, dynamic>>> cargarHistorialResultados(String userId) async {
    try {
      final databases = Databases(_client);
      final response = await databases.listDocuments(
        databaseId: _databaseId,
        collectionId: _graphicsCollectionId,
        queries: [
          Query.equal('userId', userId),
          Query.orderAsc('fechaRegistro'),
        ],
      );
      return response.documents.map((doc) => doc.data).toList();
    } catch (e) {
      print('Error al cargar el historial de gráficos para el usuario $userId: $e');
      throw e;
    }
  }

  Future<bool> yaCompletoCuestionarioHoy(String userId) async {
    try {
      final databases = Databases(_client);
      final today = DateTime.now();
      final startOfToday = DateTime(today.year, today.month, today.day).toIso8601String().split('T')[0];
      final endOfToday = DateTime(today.year, today.month, today.day, 23, 59, 59).toIso8601String();

      final response = await databases.listDocuments(
        databaseId: _databaseId,
        collectionId: _graphicsCollectionId,
        queries: [
          Query.equal('userId', userId),
          Query.greaterThanEqual('fechaRegistro', startOfToday),
          Query.lessThanEqual('fechaRegistro', endOfToday),
        ],
      );
      return response.total > 0;
    } catch (e) {
      print('Error al verificar si el usuario $userId completó el cuestionario hoy: $e');
      return false;
    }
  }
}