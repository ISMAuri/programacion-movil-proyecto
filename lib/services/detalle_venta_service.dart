import '../config/api_client.dart';
import '../models/detalle_venta.dart';

class DetalleVentaService {
  final ApiClient _apiClient = ApiClient();

  Future<List<DetalleVenta>> getDetallesPorVenta(
    int idVenta,
  ) async {
    final response = await _apiClient.dio.get(
      '/detalle-ventas/venta/$idVenta',
    );

    final List<dynamic> data = response.data;

    return data
        .map(
          (json) => DetalleVenta.fromJson(json),
        )
        .toList();
  }
}
