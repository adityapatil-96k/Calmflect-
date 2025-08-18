import 'package:flutter/material.dart';
import '../screens/dashboard/home_screen.dart';

class AppNavigator extends StatelessWidget {
  const AppNavigator({super.key});

  static const String home = '/home';

  @override
  Widget build(BuildContext context) {
    return Navigator(
      initialRoute: home,
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case home:
            return MaterialPageRoute(builder: (_) => const HomeScreen());
          default:
            return MaterialPageRoute(builder: (_) => const HomeScreen());
        }
      },
    );
  }
}
