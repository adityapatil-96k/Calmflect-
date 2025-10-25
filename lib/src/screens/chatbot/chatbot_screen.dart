import 'dart:ui';
import 'package:flutter/material.dart';
import '../../constants/colors.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _messages = [];

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;
    setState(() {
      _messages.add(_controller.text.trim());
      _controller.clear();
    });
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0F2F1), // same as HomeScreen
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Chatbot",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.slate900,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.slate900),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Chat messages
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final isUser = index % 2 == 0;
                return Align(
                  alignment:
                      isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isUser
                          ? AppColors.blue500.withValues(alpha: 0.9)
                          : Colors.white.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 6,
                          offset: const Offset(2, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      _messages[index],
                      style: TextStyle(
                        color: isUser ? Colors.white : AppColors.slate900,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Chat input bar (slightly lifted from bottom)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.slate900.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.3),
                      width: 1.2,
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          decoration: const InputDecoration(
                            hintText: "Type a message...",
                            border: InputBorder.none,
                            hintStyle: TextStyle(color: AppColors.slate900),
                          ),
                          style: const TextStyle(color: AppColors.slate900),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.send, color: AppColors.slate900),
                        onPressed: _sendMessage,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}