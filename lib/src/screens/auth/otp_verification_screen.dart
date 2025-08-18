import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../contexts/auth_context.dart';

class OTPVerificationScreen extends StatefulWidget {
  final String email;
  const OTPVerificationScreen({super.key, required this.email});

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final TextEditingController _otpController = TextEditingController();
  bool _loading = false;

  Future<void> _handleVerify(BuildContext context) async {
    final otp = _otpController.text.trim();
    if (otp.isEmpty) {
      _showAlert("Missing OTP", "Please enter the OTP sent to your email");
      return;
    }

    setState(() => _loading = true);

    try {
      final auth = Provider.of<AuthProvider>(context, listen: false);
      await auth.verifyOtp(widget.email, otp);

      // ✅ No navigation here — RootNavigation decides
      // Once verifyOtp updates auth state, app will auto switch to Home.
    } catch (e) {
      _showAlert("Verification Failed", e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  void _showAlert(String title, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // colors.background
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "Verify OTP",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6200EE), // colors.primary
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "OTP has been sent to: ${widget.email}",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black54, // colors.secondary
                ),
              ),
              const SizedBox(height: 20),

              // OTP input
              TextField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Enter OTP",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              // Verify button
              ElevatedButton(
                onPressed: _loading ? null : () => _handleVerify(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple, // colors.primary
                  padding: const EdgeInsets.symmetric(vertical: 14),
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
                        "Verify",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
