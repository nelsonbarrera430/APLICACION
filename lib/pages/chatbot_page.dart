import 'package:flutter/material.dart';
import '../services/chat_ia_service.dart';
import '../widgets/chatbot_message.dart';
import '../widgets/chatbot_input.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({Key? key}) : super(key: key);

  @override
  _ChatbotScreenState createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  final ChatIAService _chatService = ChatIAService();
  bool _isTyping = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add({'role': 'user', 'text': text});
      _isTyping = true;
      _controller.clear();
    });

    try {
      final response = await _chatService.enviarMensaje(text);
      setState(() {
        _messages.add({'role': 'bot', 'text': response});
      });
    } catch (error) {
      setState(() {
        _messages.add({
          'role': 'bot',
          'text':
              'Hubo un problema al obtener la respuesta. Intenta de nuevo.',
        });
      });
      print('Error al enviar mensaje: $error');
    } finally {
      setState(() {
        _isTyping = false;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.only(top: 50, bottom: 30),
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 0, 0, 0),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
            child: Center(
              child: Column(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 50, // Increased radius for a larger circle
                    child: Padding(
                      padding: EdgeInsets.zero, // Removed padding for the image to fill more space
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/chip.png',
                          fit: BoxFit.cover, // Cover the area, may crop edges
                          width: 100, // Match the diameter of the CircleAvatar
                          height: 100, // Match the diameter of the CircleAvatar
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),

          // Messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _messages.length,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemBuilder: (context, index) {
                return ChatbotMessage(message: _messages[index]);
              },
            ),
          ),

          // Typing indicator
          if (_isTyping)
            const Padding(
              padding: EdgeInsets.only(bottom: 8.0, left: 16.0),
              child: Row(
                children: [
                  CircularProgressIndicator(
                      strokeWidth: 2, color: Color.fromARGB(255, 18, 4, 20)),
                  SizedBox(width: 8),
                  Text("CHIP está escribiendo...",
                      style: TextStyle(color: Color.fromARGB(255, 255, 255, 255))),
                ],
              ),
            ),

          // Input
          ChatbotInput(
            controller: _controller,
            onSendMessage: _sendMessage,
          ),
        ],
      ),
    );
  }
}