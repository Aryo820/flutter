import 'package:ppkd_b6/api_3/models/user_model.dart';

class AuthResponse {
  final String message;
  final AuthData? data;

  AuthResponse({required this.message, this.data});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      message: json['message'] ?? '',
      data: json['data'] != null ? AuthData.fromJson(json['data']) : null,
    );
  }
}

class AuthData {
  final String token;
  final UserModel user;

  AuthData({required this.token, required this.user});

  factory AuthData.fromJson(Map<String, dynamic> json) {
    return AuthData(
      token: json['token'] ?? '',
      user: UserModel.fromJson(json['user']),
    );
  }
}
