import 'package:dio/dio.dart';
import '../models/login_response.dart';
import '../models/login_request.dart';

class AuthService {
  final Dio dio = Dio(BaseOptions(baseUrl: 'http://172.20.10.2:4000/api'));

  Future<LoginResponse> login(LoginRequest request) async {
    final response = await dio.post('/auth/login', data: request.toJson());
    return LoginResponse.fromJson(response.data);
  }
}
