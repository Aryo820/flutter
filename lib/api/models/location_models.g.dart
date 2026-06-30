// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocationResponse _$LocationResponseFromJson(Map<String, dynamic> json) =>
    LocationResponse(
      info: LocationInfo.fromJson(json['info'] as Map<String, dynamic>),
      results: (json['results'] as List<dynamic>)
          .map((e) => LocationFull.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$LocationResponseToJson(LocationResponse instance) =>
    <String, dynamic>{'info': instance.info, 'results': instance.results};

LocationInfo _$LocationInfoFromJson(Map<String, dynamic> json) => LocationInfo(
  count: (json['count'] as num).toInt(),
  pages: (json['pages'] as num).toInt(),
  next: json['next'] as String?,
  prev: json['prev'] as String?,
);

Map<String, dynamic> _$LocationInfoToJson(LocationInfo instance) =>
    <String, dynamic>{
      'count': instance.count,
      'pages': instance.pages,
      'next': instance.next,
      'prev': instance.prev,
    };

LocationFull _$LocationFullFromJson(Map<String, dynamic> json) => LocationFull(
  id: (json['id'] as num?)?.toInt(),
  name: json['name'] as String?,
  type: json['type'] as String?,
  dimension: json['dimension'] as String?,
  residents: (json['residents'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  url: json['url'] as String?,
  created: json['created'] == null
      ? null
      : DateTime.parse(json['created'] as String),
);

Map<String, dynamic> _$LocationFullToJson(LocationFull instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': instance.type,
      'dimension': instance.dimension,
      'residents': instance.residents,
      'url': instance.url,
      'created': instance.created?.toIso8601String(),
    };
