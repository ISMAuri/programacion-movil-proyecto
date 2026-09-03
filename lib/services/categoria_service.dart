import '../config/api_client.dart';
import '../models/categoria.dart';

class CategoriaService {
  final ApiClient _apiClient = ApiClient();

  Future<List<Categoria>> getCategorias({bool soloActivas = true}) async {
    final response = await _apiClient.dio.get(
      "/categorias",
      queryParameters: soloActivas ? {"activo": true} : null,
    );

    final List<dynamic> data = response.data;
    return data.map((json) => Categoria.fromJson(json)).toList();
  }

  Future<Categoria> postCategoria(Categoria categoria) async {
    final response = await _apiClient.dio.post(
      "/categorias",
      data: categoria.toJson(),
    );

    return Categoria.fromJson(response.data);
  }

  Future<Categoria> putCategoria(int id, Categoria categoria) async {
    final response = await _apiClient.dio.put(
      '/categorias/$id',
      data: categoria.toJson(),
    );

    return Categoria.fromJson(response.data);
  }
}
