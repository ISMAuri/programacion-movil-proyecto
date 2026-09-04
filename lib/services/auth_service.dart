import '../models/login_response.dart';
import '../models/login_request.dart';
import '../models/user.dart';
import '../config/api_client.dart';

class AuthService {
  final ApiClient _apiClient = ApiClient();

  Future<LoginResponse> login(LoginRequest request) async {
    final response = await _apiClient.dio.post(
      '/auth/login',
      data: request.toJson(),
    );
    return LoginResponse.fromJson(response.data);
  }

  Future<User> getUser(int id) async {
    final response = await _apiClient.dio.get('/auth/$id');

    return User.fromJson(response.data);
  }

  Future<User> getCurrentUser() async {
    final response = await _apiClient.dio.get('/auth/me');

    return User.fromJson(response.data);
  }
}
