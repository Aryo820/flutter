// Model untuk endpoint /api/location
import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'location_models.g.dart';

LocationResponse locationResponseFromJson(String str) =>
    LocationResponse.fromJson(json.decode(str));

String locationResponseToJson(LocationResponse data) =>
    json.encode(data.toJson());

@JsonSerializable()
class LocationResponse {
  @JsonKey(name: "info")
  LocationInfo info;
  @JsonKey(name: "results")
  List<LocationFull> results;

  LocationResponse({required this.info, required this.results});

  factory LocationResponse.fromJson(Map<String, dynamic> json) =>
      _$LocationResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LocationResponseToJson(this);
}

@JsonSerializable()
class LocationInfo {
  @JsonKey(name: "count")
  int count;
  @JsonKey(name: "pages")
  int pages;
  @JsonKey(name: "next")
  String? next;
  @JsonKey(name: "prev")
  String? prev;

  LocationInfo({
    required this.count,
    required this.pages,
    this.next,
    this.prev,
  });

  factory LocationInfo.fromJson(Map<String, dynamic> json) =>
      _$LocationInfoFromJson(json);

  Map<String, dynamic> toJson() => _$LocationInfoToJson(this);
}

@JsonSerializable()
class LocationFull {
  @JsonKey(name: "id")
  int? id;
  @JsonKey(name: "name")
  String? name;
  @JsonKey(name: "type")
  String? type;
  @JsonKey(name: "dimension")
  String? dimension;
  @JsonKey(name: "residents")
  List<String>? residents;
  @JsonKey(name: "url")
  String? url;
  @JsonKey(name: "created")
  DateTime? created;

  LocationFull({
    this.id,
    this.name,
    this.type,
    this.dimension,
    this.residents,
    this.url,
    this.created,
  });

  factory LocationFull.fromJson(Map<String, dynamic> json) =>
      _$LocationFullFromJson(json);

  Map<String, dynamic> toJson() => _$LocationFullToJson(this);
}
