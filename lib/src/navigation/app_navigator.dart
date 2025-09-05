import 'package:flutter/material.dart';
import '../screens/dashboard/home_screen.dart';
import '../screens/chatbot/chatbot_screen.dart';

class AppNavigator extends StatelessWidget {
  const AppNavigator({super.key});

  static const String home = '/home';
  static const String chatbot = '/chatbot';

  @override
  Widget build(BuildContext context) {
    return Navigator(
      initialRoute: home,
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case home:
            return MaterialPageRoute(builder: (_) => const HomeScreen());
          case chatbot:
            return MaterialPageRoute(builder: (_) => const ChatbotScreen());
          default:
            return MaterialPageRoute(builder: (_) => const HomeScreen());
        }
      },
    );
  }
}
