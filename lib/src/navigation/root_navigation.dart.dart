import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../contexts/auth_context.dart';
import 'auth_navigator.dart';
import 'app_navigator.dart';

class RootNavigation extends StatelessWidget {
  const RootNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    // Optional: splash while restoring tokens
    if (auth.loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Switch between stacks by auth state.
    // Keys ensure navigator state resets when swapping.
    return auth.isAuthenticated
        ? const AppNavigator(key: ValueKey('AppNavigator'))
        : const AuthNavigator(key: ValueKey('AuthNavigator'));
  }
}
