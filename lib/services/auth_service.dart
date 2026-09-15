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

  // Registrar un nuevo usuario
  Future<User> register({
    required String fullName,
    required String email,
    required String password,
    String role = 'user',
  }) async {
    final response = await _apiClient.dio.post(
      '/auth/register',
      data: {
        'fullName': fullName,
        'email': email,
        'password': password,
        'role': role,
      },
    );

    return User.fromJson(response.data["user"]);
  }

  // Actualizar nombre y correo del usuario autenticado
  Future<User> updateProfile({
    required String fullName,
    required String email,
  }) async {
    final response = await _apiClient.dio.put(
      '/auth/me',
      data: {'fullName': fullName, 'email': email},
    );

    return User.fromJson(response.data['user']);
  }

  // Cambiar contraseña del usuario autenticado
  Future<void> updatePassword({required String newPassword}) async {
    await _apiClient.dio.put(
      '/auth/me/password',
      data: {'passwordNueva': newPassword},
    );
  }
}
