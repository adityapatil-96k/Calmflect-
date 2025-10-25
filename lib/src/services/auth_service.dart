import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const String apiBaseUrl = 'http://10.0.2.2:5002/api/auth'; // backend URL

class AuthService {
  // ----------------------
  // API Calls
  // ----------------------

  // 1. Register new user (with phone)
  static Future<Map<String, dynamic>> registerUser(Map<String, dynamic> userData) async {
    final response = await http.post(
      Uri.parse('$apiBaseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(userData),
    );
    return jsonDecode(response.body);
  }

  // 2. Login user (sends OTP if credentials match)
  static Future<Map<String, dynamic>> loginUser(String email, String password) async {
    final response = await http.post(
      Uri.parse('$apiBaseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    return jsonDecode(response.body);
  }

  // 3. Verify OTP (for login) → also save tokens
  static Future<Map<String, dynamic>> verifyOTP(String email, String otp) async {
    final response = await http.post(
      Uri.parse('$apiBaseUrl/verify-otp'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'otp': otp, 'type': 'login'}),
    );
    final data = jsonDecode(response.body);

    // Save tokens if login successful
    if (data['success'] == true && data['tokens'] != null) {
      await _saveTokens(data['tokens']['accessToken'], data['tokens']['refreshToken']);
    }
    return data;
  }

  // 4. Logout (invalidate refresh token + clear local storage)
  static Future<void> logout(String refreshToken) async {
    final response = await http.post(
      Uri.parse('$apiBaseUrl/logout'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"refreshToken": refreshToken}),
    );

    if (response.statusCode != 200) {
      throw Exception("Logout failed: ${response.body}");
    }
  }


  // 5. Refresh access token using refresh token (called silently)
  static Future<Map<String, dynamic>> refreshAccessToken(String refreshToken) async {
    final response = await http.post(
      Uri.parse('$apiBaseUrl/refresh-token'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'refreshToken': refreshToken}),
    );

    final data = jsonDecode(response.body);
    if (data['success'] == true && data['accessToken'] != null) {
      // Save new access token
      await _saveAccessToken(data['accessToken']);
    }
    return data;
  }

  // ----------------------
  // Local Storage Helpers
  // ----------------------

  static Future<void> _saveTokens(String accessToken, String refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('accessToken', accessToken);
    await prefs.setString('refreshToken', refreshToken);
  }

  static Future<void> _saveAccessToken(String accessToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('accessToken', accessToken);
  }

  static Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  static Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('refreshToken');
  }

  static Future<void> clearTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken');
    await prefs.remove('refreshToken');
  }
}