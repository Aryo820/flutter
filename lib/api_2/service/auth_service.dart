import 'package:dio/dio.dart';
import 'package:ppkd_b6/api_2/models/auth_response.dart';
import 'package:ppkd_b6/api_2/models/profile_response.dart';
import 'package:retrofit/retrofit.dart';

part 'auth_service.g.dart';

@RestApi(baseUrl: 'https://absensib1.mobileprojp.com')
abstract class AuthService {
  factory AuthService(Dio dio, {String baseUrl}) = _AuthService;

  @POST('/api/register')
  Future<AuthResponse> register(@Body() Map<String, dynamic> body);

  @POST('/api/login')
  Future<AuthResponse> login(@Body() Map<String, dynamic> body);

  @GET('/api/profile')
  Future<ProfileResponse> getProfile();

  @PUT('/api/profile')
  Future<ProfileResponse> updateProfile(@Body() Map<String, dynamic> body);
}
