import 'package:flutter/material.dart';
import '../screens/auth/language_selector_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/registration_screen.dart';
import '../screens/auth/otp_verification_screen.dart';

class AuthNavigator extends StatelessWidget {
  const AuthNavigator({super.key});

  static const String language = '/language';
  static const String login = '/login';
  static const String register = '/register';
  static const String otp = '/otp-verification';

  @override
  Widget build(BuildContext context) {
    return Navigator(
      initialRoute: language,
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case language:
            return MaterialPageRoute(builder: (_) => const LanguageSelectorScreen());
          case login:
            return MaterialPageRoute(builder: (_) => const LoginScreen());
          case register:
            return MaterialPageRoute(builder: (_) => const RegisterScreen());
          case otp:
            // expects: arguments: {'email': '...'}
            final args = (settings.arguments ?? {}) as Map?;
            final email = (args?['email'] ?? '') as String;
            return MaterialPageRoute(
              builder: (_) => OTPVerificationScreen(email: email),
            );
          default:
            return MaterialPageRoute(builder: (_) => const LanguageSelectorScreen());
        }
      },
    );
  }
}
