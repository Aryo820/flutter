import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  static const String _keyToken = 'api3_auth_token';

  static const FlutterSecureStorage _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  /// Simpan token ke secure storage
  static Future<void> saveToken(String token) async {
    await _storage.write(key: _keyToken, value: token);
  }

  /// Ambil token dari secure storage (null jika belum login)
  static Future<String?> getToken() async {
    return _storage.read(key: _keyToken);
  }

  /// Hapus token (logout)
  static Future<void> clearToken() async {
    await _storage.delete(key: _keyToken);
  }

  /// Cek apakah user sudah login
  static Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: _keyToken);
    return token != null && token.isNotEmpty;
  }
}
