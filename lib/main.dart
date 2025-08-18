import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'src/contexts/auth_context.dart';
import 'app.dart'; // Import your main app widget

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AuthProvider(), // 👈 provides auth state everywhere
      child: const CalmflectApp(),
    ),
  );
}