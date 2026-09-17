import 'package:dio/dio.dart';
import '../services/storage_service.dart';
import 'app_constants.dart';

// ApiClient en vez de instanciar su propio Dio

// dio basico
// class ApiClient {
//   static final Dio dio = Dio(
//     BaseOptions(
//       baseUrl: 'http://10.0.2.2:4000',
//       connectTimeout: const Duration(seconds: 10),
//       receiveTimeout: const Duration(seconds: 10),
//     ),
//   );
// }

// dio preparado para autenticación con token
class ApiClient {
  ApiClient._internal() {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Agregar el token de autenticación a las cabeceras si existe
          final token = await _storageService.getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
      ),
    );
  }

  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;

  final StorageService _storageService = StorageService();

  final Dio dio = Dio(
    BaseOptions(
      baseUrl: AppConstants.baseUrl,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
    ),
  );
}
