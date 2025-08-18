import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Choose your language",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // List of languages
            Expanded(
              child: ListView.builder(
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
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSelected ? Colors.deepPurple : Colors.grey,
                        ),
                        color: isSelected ? Colors.deepPurple : Colors.transparent,
                      ),
                      child: Center(
                        child: Text(
                          lang['label']!,
                          style: TextStyle(
                            fontSize: 16,
                            color: isSelected ? Colors.white : Colors.black87,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            // Continue Button
            ElevatedButton(
              onPressed: _handleContinue,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Continue",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
