import 'package:dio/dio.dart';
import 'package:ppkd_b6/api/models/episode_models.dart';
import 'package:ppkd_b6/api/models/location_models.dart';
import 'package:ppkd_b6/api/models/post_models_rick.dart';
import 'package:retrofit/retrofit.dart';

part 'api_services.g.dart';

@RestApi(baseUrl: 'https://rickandmortyapi.com')
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  @GET('/api/character')
  Future<PostModelsRick> getAllPosts({
    @Query('page') int? page,
  });

  /// Server-side filter terhadap seluruh database.
  /// [status]  : alive | dead | unknown
  /// [gender]  : female | male | genderless | unknown
  /// API mengembalikan HTTP 404 bila tidak ada hasil — tangani sebagai list kosong.
  @GET('/api/character')
  Future<PostModelsRick> getCharacters({
    @Query('page') int? page,
    @Query('name') String? name,
    @Query('status') String? status,
    @Query('species') String? species,
    @Query('gender') String? gender,
  });

  @GET('/api/episode')
  Future<EpisodeResponse> getEpisodes({
    @Query('page') int? page,
    @Query('name') String? name,
  });

  @GET('/api/location')
  Future<LocationResponse> getLocations({
    @Query('page') int? page,
    @Query('name') String? name,
  });
}
