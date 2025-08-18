import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../contexts/auth_context.dart';

AuthProvider useAuth(BuildContext context) {
  return Provider.of<AuthProvider>(context, listen: false);
}