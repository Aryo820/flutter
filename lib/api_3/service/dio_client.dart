import 'package:dio/dio.dart';
import 'package:ppkd_b6/api_3/service/token_storage.dart';

class DioClient {
  static const String _baseUrl = 'https://appabsensi.mobileprojp.com';

  static Dio create() {
    final dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {'Accept': 'application/json'},
      ),
    );

    // Interceptor: otomatis inject Bearer token ke setiap request
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await TokenStorage.getToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) {
          handler.next(error);
        },
      ),
    );

    // Log request & response untuk debugging
    dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true),
    );

    return dio;
  }
}
