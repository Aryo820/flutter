// Model untuk endpoint /api/episode
import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'episode_models.g.dart';

EpisodeResponse episodeResponseFromJson(String str) =>
    EpisodeResponse.fromJson(json.decode(str));

String episodeResponseToJson(EpisodeResponse data) =>
    json.encode(data.toJson());

@JsonSerializable()
class EpisodeResponse {
  @JsonKey(name: "info")
  EpisodeInfo info;
  @JsonKey(name: "results")
  List<Episode> results;

  EpisodeResponse({required this.info, required this.results});

  factory EpisodeResponse.fromJson(Map<String, dynamic> json) =>
      _$EpisodeResponseFromJson(json);

  Map<String, dynamic> toJson() => _$EpisodeResponseToJson(this);
}

@JsonSerializable()
class EpisodeInfo {
  @JsonKey(name: "count")
  int count;
  @JsonKey(name: "pages")
  int pages;
  @JsonKey(name: "next")
  String? next;
  @JsonKey(name: "prev")
  String? prev;

  EpisodeInfo({
    required this.count,
    required this.pages,
    this.next,
    this.prev,
  });

  factory EpisodeInfo.fromJson(Map<String, dynamic> json) =>
      _$EpisodeInfoFromJson(json);

  Map<String, dynamic> toJson() => _$EpisodeInfoToJson(this);
}

@JsonSerializable()
class Episode {
  @JsonKey(name: "id")
  int? id;
  @JsonKey(name: "name")
  String? name;
  @JsonKey(name: "air_date")
  String? airDate;
  @JsonKey(name: "episode")
  String? episode;
  @JsonKey(name: "characters")
  List<String>? characters;
  @JsonKey(name: "url")
  String? url;
  @JsonKey(name: "created")
  DateTime? created;

  Episode({
    this.id,
    this.name,
    this.airDate,
    this.episode,
    this.characters,
    this.url,
    this.created,
  });

  factory Episode.fromJson(Map<String, dynamic> json) =>
      _$EpisodeFromJson(json);

  Map<String, dynamic> toJson() => _$EpisodeToJson(this);
}
