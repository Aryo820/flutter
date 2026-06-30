import 'package:dio/dio.dart';
import 'package:ppkd_b6/api_3/models/auth_response.dart';
import 'package:ppkd_b6/api_3/models/profile_response.dart';
import 'package:ppkd_b6/api_3/service/dio_client.dart';
import 'package:ppkd_b6/api_3/service/token_storage.dart';

class AuthService {
  final Dio _dio = DioClient.create();

  // ─────────────────────────────────────────────
  // 1. REGISTER
  // POST /api/register
  // ─────────────────────────────────────────────
  Future<AuthResponse> register({
    required String name,
    required String email,
    required String password,
    required String jenisKelamin,
    String profilePhoto = '',
    int batchId = 1,
    int trainingId = 1,
  }) async {
    final response = await _dio.post(
      '/api/register',
      data: {
        'name': name,
        'email': email,
        'password': password,
        'jenis_kelamin': jenisKelamin,
        'profile_photo': profilePhoto,
        'batch_id': batchId,
        'training_id': trainingId,
      },
    );
    final authResponse = AuthResponse.fromJson(response.data);
    // Simpan token otomatis setelah register berhasil
    if (authResponse.data?.token != null) {
      await TokenStorage.saveToken(authResponse.data!.token);
    }
    return authResponse;
  }

  // ─────────────────────────────────────────────
  // 2. LOGIN
  // POST /api/login
  // ─────────────────────────────────────────────
  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    final response = await _dio.post(
      '/api/login',
      data: {'email': email, 'password': password},
    );
    final authResponse = AuthResponse.fromJson(response.data);
    // Simpan token otomatis setelah login berhasil
    if (authResponse.data?.token != null) {
      await TokenStorage.saveToken(authResponse.data!.token);
    }
    return authResponse;
  }

  // ─────────────────────────────────────────────
  // 3. GET PROFILE
  // GET /api/profile  (membutuhkan Bearer token)
  // ─────────────────────────────────────────────
  Future<ProfileResponse> getProfile() async {
    final response = await _dio.get('/api/profile');
    return ProfileResponse.fromJson(response.data);
  }

  // ─────────────────────────────────────────────
  // 4. EDIT PROFILE (nama)
  // PUT /api/profile  (membutuhkan Bearer token)
  // ─────────────────────────────────────────────
  Future<ProfileResponse> updateProfile({required String name}) async {
    final response = await _dio.put(
      '/api/profile',
      data: {'name': name},
    );
    return ProfileResponse.fromJson(response.data);
  }

  // ─────────────────────────────────────────────
  // 5. EDIT PHOTO PROFILE
  // PUT /api/profile/photo  (membutuhkan Bearer token)
  // Body: { "profile_photo": "<base64 string>" }
  // ─────────────────────────────────────────────
  Future<ProfileResponse> updateProfilePhoto({
    required String base64Image,
  }) async {
    final response = await _dio.put(
      '/api/profile/photo',
      data: {'profile_photo': base64Image},
    );
    return ProfileResponse.fromJson(response.data);
  }

  // ─────────────────────────────────────────────
  // LOGOUT (hapus token lokal)
  // ─────────────────────────────────────────────
  Future<void> logout() async {
    await TokenStorage.clearToken();
  }
}
