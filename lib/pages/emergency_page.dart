import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import '../appwrite/appwrite_client.dart'; // Importa las instancias de los servicios
import '../appwrite/constants.dart';

class EmergencyPage extends StatefulWidget {
  const EmergencyPage({Key? key}) : super(key: key);

  @override
  _EmergencyPageState createState() => _EmergencyPageState();
}

class _EmergencyPageState extends State<EmergencyPage> {
  String? _emergencyNumber;
  String? _documentId;
  String? _userId;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadEmergencyNumberFromAppwrite();
  }

  Future<void> _loadEmergencyNumberFromAppwrite() async {
    setState(() {
      _isLoading = true;
    });
    print('Intentando cargar el número de emergencia...');
    try {
      final user = await account.get();
      print('Usuario obtenido al cargar: ${user.toMap()}');
      _userId = user.$id;
      print('ID del usuario obtenido al cargar: $_userId');

      final result = await databases.listDocuments(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.emergencyCollectionId,
        queries: [
          Query.equal('userId', _userId),
        ],
      );
      print('Resultado de la consulta de carga: ${result.toMap()}');

      if (result.documents.isNotEmpty) {
        final doc = result.documents.first;
        setState(() {
          _emergencyNumber = doc.data['emergencyNumber'];
          _documentId = doc.$id;
        });
        print('Número de emergencia cargado: $_emergencyNumber, ID del documento: $_documentId');
      } else {
        print('No se encontró número de emergencia para el usuario $_userId.');
        setState(() {
          _emergencyNumber = null;
          _documentId = null;
        });
      }
    } catch (e) {
      print('Error CRÍTICO al cargar número de emergencia: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error CRÍTICO al cargar el número de emergencia')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveEmergencyNumber(String number) async {
    print('Intentando guardar el número: $number');
    try {
      final user = await account.get();
      print('Información del usuario obtenida al guardar: ${user?.toMap()}');
      if (user != null) {
        _userId = user.$id;
        print('ID del usuario al guardar: $_userId');
      } else {
        print('Error: No se pudo obtener la información del usuario al guardar.');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error: No se pudo obtener la información del usuario')),
        );
        return;
      }

      if (_documentId != null) {
        print('Actualizando documento con ID: $_documentId, número: $number');
        await databases.updateDocument(
          databaseId: AppwriteConstants.databaseId,
          collectionId: AppwriteConstants.emergencyCollectionId,
          documentId: _documentId!,
          data: {
            'emergencyNumber': number,
          },
        );
        print('Documento actualizado exitosamente.');
      } else {
        print('Creando nuevo documento con userId: $_userId, número: $number');
        final doc = await databases.createDocument(
          databaseId: AppwriteConstants.databaseId,
          collectionId: AppwriteConstants.emergencyCollectionId,
          documentId: ID.unique(),
          data: {
            'userId': _userId,
            'emergencyNumber': number,
          },
        );
        _documentId = doc.$id;
        print('Documento creado exitosamente con ID: $_documentId.');
      }

      setState(() {
        _emergencyNumber = number;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Número de emergencia guardado')),
      );
    } catch (e) {
      print('Error guardando número (CATCH): $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al guardar el número de emergencia')),
      );
    }
  }

  Future<void> _askForNumber() async {
    final TextEditingController controller = TextEditingController(text: _emergencyNumber);
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
                _saveEmergencyNumber(controller.text.trim());
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      ),
    );
  }

  Future<void> _callEmergencyNumber() async {
    if (_emergencyNumber == null) {
      await _askForNumber();
      if (_emergencyNumber == null) return;
    }

    final Uri telUri = Uri(scheme: 'tel', path: _emergencyNumber);

    if (await canLaunchUrl(telUri)) {
      await launchUrl(telUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo realizar la llamada')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.red.shade700,
        title: const Text('Emergencia'),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.redAccent))
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.warning_amber_rounded, size: 80, color: Colors.redAccent),
                  const SizedBox(height: 20),
                  const Text(
                    'Estás en una situación de emergencia.',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.phone),
                    label: Text(_emergencyNumber == null
                        ? 'Agregar número de emergencia'
                        : 'Llamar a $_emergencyNumber'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    onPressed: _callEmergencyNumber,
                  ),
                  if (_emergencyNumber != null) ...[
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: _askForNumber,
                      child: const Text(
                        'Editar número de emergencia',
                        style: TextStyle(color: Colors.redAccent),
                      ),
                    ),
                  ],
                ],
              ),
            ),
    );
  }
}