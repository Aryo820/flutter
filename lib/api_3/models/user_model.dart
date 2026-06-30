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
      id: json['id'],
      name: json['name'],
      email: json['email'],
      emailVerifiedAt: json['email_verified_at'],
      jenisKelamin: json['jenis_kelamin'],
      profilePhoto: json['profile_photo'],
      batchId: json['batch_id'],
      trainingId: json['training_id'],
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
    );
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
