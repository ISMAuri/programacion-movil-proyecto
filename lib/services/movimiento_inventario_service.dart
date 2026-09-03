import '../config/api_client.dart';
import '../models/movimiento_inventario.dart';

class MovimientoInventarioService {
  final ApiClient _apiClient = ApiClient();

  Future<List<MovimientoInventario>> getMovimientos() async {
    final response = await _apiClient.dio.get('/movimientos_inventario');

    final List<dynamic> data = response.data;

    return data.map((json) => MovimientoInventario.fromJson(json)).toList();
  }

  Future<MovimientoInventario> getMovimiento(int id) async {
    final response = await _apiClient.dio.get('/movimientos_inventario/$id');

    return MovimientoInventario.fromJson(response.data);
  }

  Future<List<MovimientoInventario>> getMovimientosProducto(
    int idProducto,
  ) async {
    final response = await _apiClient.dio.get(
      '/movimientos_inventario/producto/$idProducto',
    );

    final List<dynamic> data = response.data;

    return data.map((json) => MovimientoInventario.fromJson(json)).toList();
  }

  Future<MovimientoInventario> postMovimiento(
    MovimientoInventario movimiento,
  ) async {
    final response = await _apiClient.dio.post(
      '/movimientos_inventario',
      data: movimiento.toJson(),
    );

    return MovimientoInventario.fromJson(response.data);
  }
}
