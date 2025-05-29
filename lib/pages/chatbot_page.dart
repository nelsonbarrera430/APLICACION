import 'package:flutter/material.dart';
import '../widgets/chatbot/chatbot_message.dart';
import '../widgets/chatbot/chatbot_input.dart';
import '../controllers/chatbot_controller.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({Key? key}) : super(key: key);

  @override
  _ChatbotScreenState createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  late final ChatbotController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ChatbotController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _sendMessage() {
    _controller.sendMessage(() {
      setState(() {});
    });
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
                    radius: 50,
                    child: Padding(
                      padding: EdgeInsets.zero,
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/chip.png',
                          fit: BoxFit.cover,
                          width: 100,
                          height: 100,
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
              controller: _controller.scrollController,
              itemCount: _controller.messages.length,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemBuilder: (context, index) {
                return ChatbotMessage(message: _controller.messages[index]);
              },
            ),
          ),

          // Typing indicator
          if (_controller.isTyping)
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
            controller: _controller.textController,
            onSendMessage: _sendMessage,
          ),
        ],
      ),
    );
  }
}
