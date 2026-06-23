import 'package:dio/dio.dart';
import 'package:ppkd_b6/api/models/post_models.dart';
import 'package:retrofit/retrofit.dart';

part 'api_services.g.dart';

@RestApi(baseUrl: 'https://jsonplaceholder.typicode.com')
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  @GET('/posts')
  Future<List<PostModels>> getAllPosts();
}
