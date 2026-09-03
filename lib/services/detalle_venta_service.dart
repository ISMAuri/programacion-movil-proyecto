import '../config/api_client.dart';
import '../models/detalle_venta.dart';

class DetalleVentaService {
  final ApiClient _apiClient = ApiClient();

  Future<DetalleVenta> getDetalleVenta(int id) async {
    final response = await _apiClient.dio.get('/detalle_ventas/$id');

    return DetalleVenta.fromJson(response.data);
  }

  Future<List<DetalleVenta>> getDetallesPorVenta(int idVenta) async {
    final response = await _apiClient.dio.get('/detalle_ventas/venta/$idVenta');

    final List<dynamic> data = response.data;

    return data.map((json) => DetalleVenta.fromJson(json)).toList();
  }

  Future<List<DetalleVenta>> getDetallesPorProducto(int idProducto) async {
    final response = await _apiClient.dio.get(
      '/detalle_ventas/producto/$idProducto',
    );

    final List<dynamic> data = response.data;

    return data.map((json) => DetalleVenta.fromJson(json)).toList();
  }
}
