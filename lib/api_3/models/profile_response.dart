import 'package:ppkd_b6/api_3/models/user_model.dart';

class ProfileResponse {
  final String? message;
  final UserModel? data;

  ProfileResponse({this.message, this.data});

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    return ProfileResponse(
      message: json['message'],
      data: json['data'] != null ? UserModel.fromJson(json['data']) : null,
    );
  }
}
