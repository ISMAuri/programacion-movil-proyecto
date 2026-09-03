import '../config/api_client.dart';
import '../models/producto.dart';

class ProductoService {
  final ApiClient _apiClient = ApiClient();

  Future<List<Producto>> getProductos({bool soloActivos = true}) async {
    final response = await _apiClient.dio.get(
      '/productos',
      queryParameters: soloActivos ? {'estado': true} : null,
    );

    final List<dynamic> data = response.data;

    return data.map((json) => Producto.fromJson(json)).toList();
  }

  Future<Producto> getProducto(int id) async {
    final response = await _apiClient.dio.get('/productos/$id');

    return Producto.fromJson(response.data);
  }

  Future<Producto> postProducto(Producto producto) async {
    final response = await _apiClient.dio.post(
      '/productos',
      data: producto.toJson(),
    );

    return Producto.fromJson(response.data);
  }

  Future<Producto> putProducto(int id, Producto producto) async {
    final response = await _apiClient.dio.put(
      '/productos/$id',
      data: producto.toJson(),
    );

    return Producto.fromJson(response.data);
  }

  Future<void> deleteProducto(int id) async {
    await _apiClient.dio.delete('/productos/$id');
  }
}
