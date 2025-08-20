import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../contexts/auth_context.dart';
import '../../Templates/base_template.dart';
import '../../constants/colors.dart';
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
                  "Verify OTP",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: AppColors.slate900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "OTP has been sent to: ${widget.email}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.slate900,
                  ),
                ),
                const SizedBox(height: 28),

                // OTP input
                TextField(
                  controller: _otpController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Enter OTP",
                    prefixIcon: const Icon(Icons.lock_open_outlined),
                    filled: true,
                    fillColor: const Color(0xFFF8FAFC), // slate-50
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.slate900),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Verify button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _loading ? null : () => _handleVerify(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.slate900,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
