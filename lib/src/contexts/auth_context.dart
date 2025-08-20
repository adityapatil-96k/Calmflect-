import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart'; // <-- You need to implement this

class AuthProvider with ChangeNotifier {
  Map<String, dynamic>? _user;
  String? _accessToken;
  bool _loading = true;

  AuthProvider() {
    _loadStoredData();
  }

  Map<String, dynamic>? get user => _user;
  String? get accessToken => _accessToken;
  bool get isAuthenticated => _accessToken != null;
  bool get loading => _loading;

  Future<void> _loadStoredData() async {
    final prefs = await SharedPreferences.getInstance();
    final storedToken = prefs.getString('accessToken');
    if (storedToken != null) {
      _accessToken = storedToken;
    }
    _loading = false;
    notifyListeners();
  }

  Future<Map<String, bool>> login(String email, String password) async {
    try {
      final res = await AuthService.loginUser(email, password);

      if (res['otpRequired'] == true) {
        return {'otpRequired': true};
      }

      if (res['accessToken'] != null && res['refreshToken'] != null) {
        _accessToken = res['accessToken'];
        _user = {'email': email};

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('accessToken', res['accessToken']);
        await prefs.setString('refreshToken', res['refreshToken']);

        notifyListeners();
        return {'otpRequired': false};
      }

      throw Exception(res['message'] ?? 'Unexpected login response');
    } catch (e) {
      debugPrint('Login Failed: $e');
      rethrow;
    }
  }

  Future<void> verifyOtp(String email, String otp) async {
    try {
      final res = await AuthService.verifyOTP(email, otp);

      if (res['accessToken'] != null && res['refreshToken'] != null) {
        _accessToken = res['accessToken'];
        _user = {'email': email};

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('accessToken', res['accessToken']);
        await prefs.setString('refreshToken', res['refreshToken']);

        notifyListeners();
      } else {
        throw Exception('Tokens not received');
      }
    } catch (e) {
      debugPrint('OTP Verification Failed: $e');
      rethrow;
    }
  }

Future<Map<String, dynamic>> register(
    String name, String email, String phone, String password) async {
  try {
    final res = await AuthService.registerUser({
      'name': name,
      'email': email,
      'phone': phone,
      'password': password,
    });

    // ✅ Just return backend response (let UI decide what to do)
    return res;
  } catch (e) {
    debugPrint('Registration Failed: $e');
    // return a unified error response (so UI doesn’t break)
    return {'message': 'error', 'error': e.toString()};
  }
}



  Future<void> refreshToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final storedRefreshToken = prefs.getString('refreshToken');
      if (storedRefreshToken == null) throw Exception('No refresh token stored');

      final res = await AuthService.refreshAccessToken(storedRefreshToken);

      if (res['accessToken'] != null) {
        _accessToken = res['accessToken'];
        await prefs.setString('accessToken', res['accessToken']);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Refresh token failed: $e');
      await logout();
    }
  }

  Future<void> logout() async {
    _user = null;
    _accessToken = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken');
    await prefs.remove('refreshToken');

    notifyListeners();
  }
}
