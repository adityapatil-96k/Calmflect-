import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../contexts/auth_context.dart';
import '../../Templates/base_template.dart';
import '../../constants/colors.dart';
import '../../components/Buttons/custom_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _goToLogin(BuildContext context) async {
    final auth = Provider.of<AuthProvider>(context, listen: false);

    // Call logout
    await auth.logout();

    if (context.mounted) {
      // Navigate back to login page
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseTemplate(
      // backgroundColor: const Color(0xFFF5F5F5), // Replace with your colors.background
      // body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          height: MediaQuery.of(context).size.height,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Welcome to CalmFlect",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.slate800, // Replace with your colors.primary
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              const Text(
                "Your mental health companion app. Stay calm, reflect, and thrive.",
                style: TextStyle(
                  fontSize: 18,
                  color: AppColors.slate700, // Replace with your colors.text
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              CustomButton(
                onPressed: () => _goToLogin(context),
                text: "Logout",
                backgroundColor: AppColors.slate900, // Replace with your colors.primary
                borderRadius: 20,
                width: 100,
                
              ),
            ],
          ),
        ),
      );
    // );
  }
}
