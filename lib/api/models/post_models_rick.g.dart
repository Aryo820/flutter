// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_models_rick.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostModelsRick _$PostModelsRickFromJson(Map<String, dynamic> json) =>
    PostModelsRick(
      info: Info.fromJson(json['info'] as Map<String, dynamic>),
      results: (json['results'] as List<dynamic>)
          .map((e) => Result.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PostModelsRickToJson(PostModelsRick instance) =>
    <String, dynamic>{'info': instance.info, 'results': instance.results};

Info _$InfoFromJson(Map<String, dynamic> json) => Info(
  count: (json['count'] as num).toInt(),
  pages: (json['pages'] as num).toInt(),
  next: json['next'] as String?,
  prev: json['prev'],
);

Map<String, dynamic> _$InfoToJson(Info instance) => <String, dynamic>{
  'count': instance.count,
  'pages': instance.pages,
  'next': instance.next,
  'prev': instance.prev,
};

Result _$ResultFromJson(Map<String, dynamic> json) => Result(
  id: (json['id'] as num?)?.toInt(),
  name: json['name'] as String?,
  status: $enumDecodeNullable(
    _$StatusEnumMap,
    json['status'],
    unknownValue: Status.UNKNOWN,
  ),
  species: json['species'] as String?,
  type: json['type'] as String?,
  gender: $enumDecodeNullable(
    _$GenderEnumMap,
    json['gender'],
    unknownValue: Gender.UNKNOWN,
  ),
  origin: json['origin'] == null
      ? null
      : Location.fromJson(json['origin'] as Map<String, dynamic>),
  location: json['location'] == null
      ? null
      : Location.fromJson(json['location'] as Map<String, dynamic>),
  image: json['image'] as String?,
  episode: (json['episode'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  url: json['url'] as String?,
  created: json['created'] == null
      ? null
      : DateTime.parse(json['created'] as String),
);

Map<String, dynamic> _$ResultToJson(Result instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'status': _$StatusEnumMap[instance.status],
  'species': instance.species,
  'type': instance.type,
  'gender': _$GenderEnumMap[instance.gender],
  'origin': instance.origin,
  'location': instance.location,
  'image': instance.image,
  'episode': instance.episode,
  'url': instance.url,
  'created': instance.created?.toIso8601String(),
};

const _$StatusEnumMap = {
  Status.ALIVE: 'Alive',
  Status.DEAD: 'Dead',
  Status.UNKNOWN: 'unknown',
};

const _$GenderEnumMap = {
  Gender.FEMALE: 'Female',
  Gender.MALE: 'Male',
  Gender.GENDERLESS: 'Genderless',
  Gender.UNKNOWN: 'unknown',
};

Location _$LocationFromJson(Map<String, dynamic> json) =>
    Location(name: json['name'] as String, url: json['url'] as String);

Map<String, dynamic> _$LocationToJson(Location instance) => <String, dynamic>{
  'name': instance.name,
  'url': instance.url,
};
