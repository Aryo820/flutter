// To parse this JSON data, do
//
//     final postModels = postModelsFromJson(jsonString);

import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'post_models.g.dart';

List<PostModels> postModelsFromJson(String str) =>
    List<PostModels>.from(json.decode(str).map((x) => PostModels.fromJson(x)));

String postModelsToJson(List<PostModels> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@JsonSerializable()
class PostModels {
  @JsonKey(name: "userId")
  int userId;
  @JsonKey(name: "id")
  int id;
  @JsonKey(name: "title")
  String title;
  @JsonKey(name: "body")
  String body;

  PostModels({
    required this.userId,
    required this.id,
    required this.title,
    required this.body,
  });

  factory PostModels.fromJson(Map<String, dynamic> json) =>
      _$PostModelsFromJson(json);

  Map<String, dynamic> toJson() => _$PostModelsToJson(this);
}
