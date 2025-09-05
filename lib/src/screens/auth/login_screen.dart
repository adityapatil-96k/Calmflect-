import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../contexts/auth_context.dart';
import '../../Templates/base_template.dart';
import '../../constants/colors.dart';
import '../../components/Buttons/custom_button.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _loading = false;
  bool _obscurePassword = true;

  Future<void> _handleLogin() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showAlert("Missing fields", "Please fill in both email and password");
      return;
    }

    setState(() => _loading = true);

    try {
      final result = await auth.login(email, password);

      if (!mounted) return; // ✅ safe check before using context

      if (result['otpRequired'] == true) {
        Navigator.pushNamed(
          context,
          '/otp-verification',
          arguments: {'email': email},
        );
      }
    } catch (e) {
      if (!mounted) return; // ✅ prevent dialog if screen disposed
      _showAlert("Login Failed", e.toString());
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  void _goToRegister() {
    Navigator.pushNamed(context, '/register');
  }

  void _showAlert(String title, String message) {
  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(), // ✅ Correct
            child: const Text("OK"),
          ),
        ],
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    return BaseTemplate(
      // backgroundColor: const Color(0xFFF5F5F5),
      // body: Padding(
      //   padding: const EdgeInsets.all(20),
        child: Center(
  child: SingleChildScrollView(
    child: Container(
      padding: const EdgeInsets.all(24),
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Title
          const Text(
            "Login",
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: AppColors.slate900, // slate-800
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Welcome back 👋",
            style: TextStyle(
              fontSize: 14,
              color: AppColors.slate900, // slate-700
            ),
          ),
          const SizedBox(height: 28),

          // Email input
          TextField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: "Email",
              prefixIcon: const Icon(Icons.email_outlined),
              filled: true,
              fillColor: const Color(0xFFF8FAFC), // slate-50
              border: OutlineInputBorder(
                 borderSide: BorderSide(color: AppColors.slate900),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),

          // Password input
          TextField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            decoration: InputDecoration(
              labelText: "Password",
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
              filled: true,
              fillColor: const Color(0xFFF8FAFC),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.slate900), // slate-300
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Login Button
   

          CustomButton(
            onPressed: () => _handleLogin(),
            text: "Login",
            backgroundColor: AppColors.slate900,
            borderRadius: 12,
            isLoading: _loading,
          ),
          const SizedBox(height: 20),

          // Go to Register
          GestureDetector(
            onTap: _goToRegister,
            child: const Text(
              "Don't have an account? Register",
              style: TextStyle(
                color: AppColors.slate900,
                fontWeight: FontWeight.w500,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    ),
  ),
),
      );
    // );
  }
}
