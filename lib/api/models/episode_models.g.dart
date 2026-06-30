// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'episode_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EpisodeResponse _$EpisodeResponseFromJson(Map<String, dynamic> json) =>
    EpisodeResponse(
      info: EpisodeInfo.fromJson(json['info'] as Map<String, dynamic>),
      results: (json['results'] as List<dynamic>)
          .map((e) => Episode.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$EpisodeResponseToJson(EpisodeResponse instance) =>
    <String, dynamic>{'info': instance.info, 'results': instance.results};

EpisodeInfo _$EpisodeInfoFromJson(Map<String, dynamic> json) => EpisodeInfo(
  count: (json['count'] as num).toInt(),
  pages: (json['pages'] as num).toInt(),
  next: json['next'] as String?,
  prev: json['prev'] as String?,
);

Map<String, dynamic> _$EpisodeInfoToJson(EpisodeInfo instance) =>
    <String, dynamic>{
      'count': instance.count,
      'pages': instance.pages,
      'next': instance.next,
      'prev': instance.prev,
    };

Episode _$EpisodeFromJson(Map<String, dynamic> json) => Episode(
  id: (json['id'] as num?)?.toInt(),
  name: json['name'] as String?,
  airDate: json['air_date'] as String?,
  episode: json['episode'] as String?,
  characters: (json['characters'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  url: json['url'] as String?,
  created: json['created'] == null
      ? null
      : DateTime.parse(json['created'] as String),
);

Map<String, dynamic> _$EpisodeToJson(Episode instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'air_date': instance.airDate,
  'episode': instance.episode,
  'characters': instance.characters,
  'url': instance.url,
  'created': instance.created?.toIso8601String(),
};
