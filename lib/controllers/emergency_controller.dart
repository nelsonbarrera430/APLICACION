import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import '../appwrite/appwrite_client.dart';
import '../appwrite/constants.dart';

class EmergencyController {
  String? emergencyNumber;
  String? documentId;
  String? userId;
  bool isLoading = true;

  final BuildContext context;

  EmergencyController(this.context);

  Future<void> loadEmergencyNumber() async {
    isLoading = true;
    try {
      final user = await account.get();
      userId = user.$id;

      final result = await databases.listDocuments(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.emergencyCollectionId,
        queries: [Query.equal('userId', userId)],
      );

      if (result.documents.isNotEmpty) {
        final doc = result.documents.first;
        emergencyNumber = doc.data['emergencyNumber'];
        documentId = doc.$id;
      } else {
        emergencyNumber = null;
        documentId = null;
      }
    } catch (e) {
      _showError('Error CRÍTICO al cargar el número de emergencia');
    } finally {
      isLoading = false;
    }
  }

  Future<void> saveEmergencyNumber(String number) async {
    try {
      final user = await account.get();
      userId = user.$id;

      if (documentId != null) {
        await databases.updateDocument(
          databaseId: AppwriteConstants.databaseId,
          collectionId: AppwriteConstants.emergencyCollectionId,
          documentId: documentId!,
          data: {'emergencyNumber': number},
        );
      } else {
        final doc = await databases.createDocument(
          databaseId: AppwriteConstants.databaseId,
          collectionId: AppwriteConstants.emergencyCollectionId,
          documentId: ID.unique(),
          data: {'userId': userId, 'emergencyNumber': number},
        );
        documentId = doc.$id;
      }

      emergencyNumber = number;
      _showMessage('Número de emergencia guardado');
    } catch (e) {
      _showError('Error al guardar el número de emergencia');
    }
  }

  Future<void> askForNumber() async {
    final TextEditingController controller = TextEditingController(text: emergencyNumber);
    final formKey = GlobalKey<FormState>();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Número de emergencia'),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: controller,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              labelText: 'Ingresa el número',
              hintText: '+1234567890',
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Por favor ingresa un número válido';
              }
              return null;
            },
          ),
        ),
        actions: [
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          ElevatedButton(
            child: const Text('Guardar'),
            onPressed: () {
              if (formKey.currentState!.validate()) {
                saveEmergencyNumber(controller.text.trim());
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      ),
    );
  }

  Future<void> callEmergencyNumber() async {
    if (emergencyNumber == null) {
      await askForNumber();
      if (emergencyNumber == null) return;
    }

    final Uri telUri = Uri(scheme: 'tel', path: emergencyNumber);

    if (await canLaunchUrl(telUri)) {
      await launchUrl(telUri);
    } else {
      _showError('No se pudo realizar la llamada');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}
