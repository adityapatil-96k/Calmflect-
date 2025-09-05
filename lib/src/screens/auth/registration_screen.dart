import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../contexts/auth_context.dart';
import '../../Templates/base_template.dart';
import '../../constants/colors.dart';
import '../../components/Buttons/custom_button.dart';

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
  bool _obscurePassword = true;

  Future<void> _handleRegister(BuildContext context) async {
  final name = _nameController.text.trim();
  final email = _emailController.text.trim();
  final phone = _phoneController.text.trim();
  final password = _passwordController.text.trim();

  if (name.isEmpty || email.isEmpty || phone.isEmpty || password.isEmpty) {
    _showAlert("Missing Fields", "Please fill in all fields");
    return;
  }

  setState(() => _loading = true);

  try {
    // Step 1: Call register
    final res = await context
        .read<AuthProvider>()
        .register(name, email, phone, password);

    if (!mounted) return;

    if (res['message'] == "User registered successfully") {
      // Step 2: Auto-login with same credentials

      await this.context.read<AuthProvider>().login(email, password);

      if (!mounted) return;
      // Navigate to OTP verification screen
      Navigator.pushNamed(this.context, '/otp-verification', arguments: {'email': email});
      // ✅ OTP → Home handled by AuthProvider

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
    Navigator.pushNamed(context, '/login');
  }

  void _showAlert(String title, String message, {bool redirectToLogin = false}) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              if (redirectToLogin) {
                _goToLogin(context);
              }
            },
            child: const Text("OK"),
          )
        ],
      ),  
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return BaseTemplate(
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
                  "Register",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: AppColors.slate900,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Create your account ✨",
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.slate900,
                  ),
                ),
                const SizedBox(height: 28),

                // Name
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: "Name",
                    prefixIcon: const Icon(Icons.person_outline),
                    filled: true,
                    fillColor: const Color(0xFFF8FAFC), // slate-50
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.slate900),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Email
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    prefixIcon: const Icon(Icons.email_outlined),
                    filled: true,
                    fillColor: const Color(0xFFF8FAFC),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.slate900),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),

                // Phone
                TextField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: "Phone",
                    prefixIcon: const Icon(Icons.phone_outlined),
                    filled: true,
                    fillColor: const Color(0xFFF8FAFC),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.slate900),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),

                // Password
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
                      borderSide: BorderSide(color: AppColors.slate900),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Register button


                CustomButton(
                  onPressed: () => _handleRegister(context),
                  text: "Register",
                  backgroundColor: AppColors.slate900,
                  borderRadius: 12,
                  isLoading: _loading,
                ),
                const SizedBox(height: 20),

                
                // Link to Login
                GestureDetector(
                  onTap: () => _goToLogin(context),
                  child: const Text(
                    "Already have an account? Login",
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
  }
  
}
