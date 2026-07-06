// Response untuk GET /api/users (All data user) -> List<UserModel>
class UserListResponse {
  final String? message;
  final List<UserModel> data;

  UserListResponse({this.message, this.data = const []});

  factory UserListResponse.fromJson(Map<String, dynamic> json) {
    final list = json['data'];
    return UserListResponse(
      message: json['message'],
      data: list is List
          ? list
              .whereType<Map<String, dynamic>>()
              .map(UserModel.fromJson)
              .toList()
          : const [],
    );
  }
}

class UserModel {
  final int? id;
  final String? name;
  final String? email;
  final dynamic emailVerifiedAt;
  final String? jenisKelamin;
  final String? profilePhoto;
  final int? batchId;
  final int? trainingId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserModel({
    this.id,
    this.name,
    this.email,
    this.emailVerifiedAt,
    this.jenisKelamin,
    this.profilePhoto,
    this.batchId,
    this.trainingId,
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: _toInt(json['id']),
      name: json['name'],
      email: json['email'],
      emailVerifiedAt: json['email_verified_at'],
      jenisKelamin: json['jenis_kelamin'],
      profilePhoto: json['profile_photo'],
      batchId: _toInt(json['batch_id']),
      trainingId: _toInt(json['training_id']),
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'].toString())
          : null,
    );
  }

  // Konversi aman: terima int, String, atau null dari API
  static int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    if (value is double) return value.toInt();
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'email_verified_at': emailVerifiedAt,
      'jenis_kelamin': jenisKelamin,
      'profile_photo': profilePhoto,
      'batch_id': batchId,
      'training_id': trainingId,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
