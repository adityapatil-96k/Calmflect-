import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../Templates/base_template.dart';
import '../../constants/colors.dart';

class LanguageSelectorScreen extends StatefulWidget {
  const LanguageSelectorScreen({super.key});

  @override
  State<LanguageSelectorScreen> createState() => _LanguageSelectorScreenState();
}

class _LanguageSelectorScreenState extends State<LanguageSelectorScreen> {
  String _selectedLanguage = 'en';

  final storage = const FlutterSecureStorage();

  final List<Map<String, String>> availableLanguages = [
    {'code': 'en', 'label': 'English'},
    {'code': 'hi', 'label': 'हिंदी'},
    {'code': 'mr', 'label': 'मराठी'},
    {'code': 'bn', 'label': 'বাংলা'},
    {'code': 'ta', 'label': 'தமிழ்'},
  ];

  void _handleLanguageSelect(String code) {
    setState(() {
      _selectedLanguage = code;
    });
  }

  Future<void> _handleContinue() async {
    // ✅ Save selectedLanguage securely
    await storage.write(key: 'selectedLanguage', value: _selectedLanguage);

    // ✅ Use mounted check with this.state context
    if (!mounted) return;

    Navigator.pushNamed(context, '/register');
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
              color: Colors.white.withAlpha(230), // ✅ same as OTP screen
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(20),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Choose your language",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.slate900,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                // Language list
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: availableLanguages.length,
                  itemBuilder: (context, index) {
                    final lang = availableLanguages[index];
                    final isSelected = _selectedLanguage == lang['code'];

                    return GestureDetector(
                      onTap: () => _handleLanguageSelect(lang['code']!),
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.slate900
                                : Colors.grey.shade400,
                            width: 1.5,
                          ),
                          color: isSelected ? AppColors.slate900 : Colors.white,
                        ),
                        child: Center(
                          child: Text(
                            lang['label']!,
                            style: TextStyle(
                              fontSize: 16,
                              color: isSelected ? Colors.white : AppColors.slate900,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 24),

                // Continue button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _handleContinue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.slate900,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                    ),
                    child: const Text(
                      "Continue",
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
