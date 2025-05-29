// Importaciones existentes
import 'package:flutter/material.dart';
import '../controllers/emergency_controller.dart';

class EmergencyPage extends StatefulWidget {
  const EmergencyPage({Key? key}) : super(key: key);

  @override
  _EmergencyPageState createState() => _EmergencyPageState();
}

class _EmergencyPageState extends State<EmergencyPage> {
  late EmergencyController _controller;

  @override
  void initState() {
    super.initState();
    _controller = EmergencyController(context);
    _loadData();
  }

  Future<void> _loadData() async {
    await _controller.loadEmergencyNumber();
    setState(() {});
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
      body: _controller.isLoading
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
                    label: Text(
                      _controller.emergencyNumber == null
                          ? 'Agregar número de emergencia'
                          : 'Llamar a ${_controller.emergencyNumber}',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    onPressed: () async {
                      await _controller.callEmergencyNumber();
                      setState(() {});
                    },
                  ),
                  if (_controller.emergencyNumber != null) ...[
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () async {
                        await _controller.askForNumber();
                        setState(() {});
                      },
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
