
import 'dart:convert';
import 'package:http/http.dart' as http;

const String  apiBaseUrl = 'https://authservice-m94n.onrender.com/api/auth'; // replace with your actual backend URL

class AuthService {
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

  // 3. Verify OTP (for login)
  static Future<Map<String, dynamic>> verifyOTP(String email, String otp) async {
    final response = await http.post(
      Uri.parse('$apiBaseUrl/verify-otp'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'otp': otp, 'type': 'login'}),
    );
    return jsonDecode(response.body);
  }

  // 4. Logout (invalidate refresh token)
  static Future<Map<String, dynamic>> logoutUser(String refreshToken) async {
    final response = await http.post(
      Uri.parse('$apiBaseUrl/logout'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'refreshToken': refreshToken}),
    );
    return jsonDecode(response.body);
  }

  // 5. Refresh access token using refresh token (called silently)
  static Future<Map<String, dynamic>> refreshAccessToken(String refreshToken) async {
    final response = await http.post(
      Uri.parse('$apiBaseUrl/refresh-token'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'refreshToken': refreshToken}),
    );
    return jsonDecode(response.body);
  }
}