// To parse this JSON data, do
//
//     final postModelsRick = postModelsRickFromJson(jsonString);

import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'post_models_rick.g.dart';

PostModelsRick postModelsRickFromJson(String str) =>
    PostModelsRick.fromJson(json.decode(str));

String postModelsRickToJson(PostModelsRick data) => json.encode(data.toJson());

@JsonSerializable()
class PostModelsRick {
  @JsonKey(name: "info")
  Info info;
  @JsonKey(name: "results")
  List<Result> results;

  PostModelsRick({required this.info, required this.results});

  factory PostModelsRick.fromJson(Map<String, dynamic> json) =>
      _$PostModelsRickFromJson(json);

  Map<String, dynamic> toJson() => _$PostModelsRickToJson(this);
}

@JsonSerializable()
class Info {
  @JsonKey(name: "count")
  int count;
  @JsonKey(name: "pages")
  int pages;
  @JsonKey(name: "next")
  String? next;
  @JsonKey(name: "prev")
  dynamic prev;

  Info({
    required this.count,
    required this.pages,
    this.next,
    this.prev,
  });

  factory Info.fromJson(Map<String, dynamic> json) => _$InfoFromJson(json);

  Map<String, dynamic> toJson() => _$InfoToJson(this);
}

@JsonSerializable()
class Result {
  @JsonKey(name: "id")
  int? id;
  @JsonKey(name: "name")
  String? name;
  @JsonKey(name: "status", unknownEnumValue: Status.UNKNOWN)
  Status? status;
  @JsonKey(name: "species")
  String? species;
  @JsonKey(name: "type")
  String? type;
  @JsonKey(name: "gender", unknownEnumValue: Gender.UNKNOWN)
  Gender? gender;
  @JsonKey(name: "origin")
  Location? origin;
  @JsonKey(name: "location")
  Location? location;
  @JsonKey(name: "image")
  String? image;
  @JsonKey(name: "episode")
  List<String>? episode;
  @JsonKey(name: "url")
  String? url;
  @JsonKey(name: "created")
  DateTime? created;

  Result({
    this.id,
    this.name,
    this.status,
    this.species,
    this.type,
    this.gender,
    this.origin,
    this.location,
    this.image,
    this.episode,
    this.url,
    this.created,
  });

  factory Result.fromJson(Map<String, dynamic> json) => _$ResultFromJson(json);

  Map<String, dynamic> toJson() => _$ResultToJson(this);
}

enum Gender {
  @JsonValue("Female")
  FEMALE,
  @JsonValue("Male")
  MALE,
  @JsonValue("Genderless")
  GENDERLESS,
  @JsonValue("unknown")
  UNKNOWN,
}

final genderValues = EnumValues({
  "Female": Gender.FEMALE,
  "Male": Gender.MALE,
  "Genderless": Gender.GENDERLESS,
  "unknown": Gender.UNKNOWN,
});

@JsonSerializable()
class Location {
  @JsonKey(name: "name")
  String name;
  @JsonKey(name: "url")
  String url;

  Location({required this.name, required this.url});

  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);

  Map<String, dynamic> toJson() => _$LocationToJson(this);
}

enum Status {
  @JsonValue("Alive")
  ALIVE,
  @JsonValue("Dead")
  DEAD,
  @JsonValue("unknown")
  UNKNOWN,
}

final statusValues = EnumValues({
  "Alive": Status.ALIVE,
  "Dead": Status.DEAD,
  "unknown": Status.UNKNOWN,
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
