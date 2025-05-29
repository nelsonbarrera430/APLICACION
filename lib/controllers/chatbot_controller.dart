import 'package:flutter/material.dart';
import '../services/chat_ia_service.dart';

class ChatbotController {
  final TextEditingController textController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final ChatIAService chatService = ChatIAService();

  final List<Map<String, dynamic>> _messages = [];
  bool _isTyping = false;

  // Exponer mensajes e isTyping para el widget (getters)
  List<Map<String, dynamic>> get messages => List.unmodifiable(_messages);
  bool get isTyping => _isTyping;

  void dispose() {
    textController.dispose();
    scrollController.dispose();
  }

  Future<void> sendMessage(VoidCallback updateUI) async {
    final text = textController.text.trim();
    if (text.isEmpty) return;

    _messages.add({'role': 'user', 'text': text});
    _isTyping = true;
    textController.clear();

    updateUI(); 

    try {
      final response = await chatService.enviarMensaje(text);
      _messages.add({'role': 'bot', 'text': response});
    } catch (error) {
      _messages.add({
        'role': 'bot',
        'text': 'Hubo un problema al obtener la respuesta. Intenta de nuevo.',
      });
      print('Error al enviar mensaje: $error');
    } finally {
      _isTyping = false;
      updateUI(); 

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (scrollController.hasClients) {
          scrollController.animateTo(
            scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      });
    }
  }
}
