import 'package:flutter/material.dart';
import '../../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _loading = false;

  Future<void> _handleRegister(BuildContext context) async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();
    final password = _passwordController.text.trim();

    if (name.isEmpty || email.isEmpty || phone.isEmpty || password.isEmpty) {
      if (!mounted) return;
      _showAlert("Missing Fields", "Please fill in all fields");
      return;
    }

    setState(() => _loading = true);

    try {
      final res = await AuthService.registerUser({
        'name': name,
        'email': email,
        'phone': phone,
        'password': password,
      });

      if (!mounted) return;

      if (res['success'] == true) {
        // ✅ Directly go to HomeScreen on success
        if (!mounted) return;
        Navigator.pushNamedAndRemoveUntil(
          context,'/home',
          (route) => false,
        );
      } else if (res['message'] == "Email already exists") {
        // ✅ Show alert and then redirect to login
        if (!mounted) return;
        _showAlert(
          "Email Exists",
          "This email is already registered. Redirecting to login...",
          redirectToLogin: true,
        );
      } else {
        throw Exception(res['message'] ?? "Registration failed");
      }
    } catch (e) {
      if (!mounted) return;
      _showAlert("Registration Failed", e.toString());
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  void _goToLogin(BuildContext context) {
    if (!mounted) return;
    Navigator.pushNamed(context, '/login');
  }

  void _showAlert(String title, String message, {bool redirectToLogin = false}) {
    if (!mounted) return; // prevent showing dialog after unmount
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop(); // close dialog
              
                Navigator.pushNamed(context, '/login');
              
            },
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    // cleanup controllers
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 30),
              const Text(
                "Register",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6200EE),
                ),
              ),
              const SizedBox(height: 30),

              // Name input
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "Name",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Email input
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),

              // Phone input
              TextField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: "Phone",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),

              // Password input
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),

              // Register button
              ElevatedButton(
                onPressed: _loading ? null : () => _handleRegister(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _loading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        "Register",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
              ),

              const SizedBox(height: 20),

              // Go to Login
              GestureDetector(
                onTap: () => _goToLogin(context),
                child: const Text(
                  "Already have an account? Login",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
