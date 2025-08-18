import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = FlutterSecureStorage();

Future<void> storeAccessToken(String token) async {
  await storage.write(key: 'accessToken', value: token);
}

Future<String?> getAccessToken() async {
  return await storage.read(key: 'accessToken');
}

Future<void> clearTokens() async {
  await storage.delete(key: 'accessToken');
}