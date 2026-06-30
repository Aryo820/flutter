// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthResponse _$AuthResponseFromJson(Map<String, dynamic> json) => AuthResponse(
  message: json['message'] as String,
  data: Data.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AuthResponseToJson(AuthResponse instance) =>
    <String, dynamic>{'message': instance.message, 'data': instance.data};

Data _$DataFromJson(Map<String, dynamic> json) => Data(
  token: json['token'] as String,
  user: User.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
  'token': instance.token,
  'user': instance.user,
};

User _$UserFromJson(Map<String, dynamic> json) => User(
  name: json['name'] as String,
  email: json['email'] as String,
  updatedAt: DateTime.parse(json['updated_at'] as String),
  createdAt: DateTime.parse(json['created_at'] as String),
  id: (json['id'] as num).toInt(),
);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'name': instance.name,
  'email': instance.email,
  'updated_at': instance.updatedAt.toIso8601String(),
  'created_at': instance.createdAt.toIso8601String(),
  'id': instance.id,
};
