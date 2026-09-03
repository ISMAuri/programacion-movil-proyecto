import '../config/api_client.dart';
import '../models/autorizacion_factura.dart';

class AutorizacionFacturaService {
  final ApiClient _apiClient = ApiClient();

  Future<List<AutorizacionFactura>> getAutorizaciones({
    bool soloActivas = true,
  }) async {
    final response = await _apiClient.dio.get(
      '/autorizacion_facturas',
      queryParameters: soloActivas ? {'estado': true} : null,
    );

    final List<dynamic> data = response.data;

    return data.map((json) => AutorizacionFactura.fromJson(json)).toList();
  }

  Future<AutorizacionFactura> getAutorizacion(int id) async {
    final response = await _apiClient.dio.get('/autorizacion_facturas/$id');

    return AutorizacionFactura.fromJson(response.data);
  }

  Future<List<AutorizacionFactura>> getAutorizacionesActivasEmpresa(
    int idEmpresa,
  ) async {
    final response = await _apiClient.dio.get(
      '/autorizacion_facturas/empresa/$idEmpresa/activas',
    );

    final List<dynamic> data = response.data;

    return data.map((json) => AutorizacionFactura.fromJson(json)).toList();
  }

  Future<AutorizacionFactura> postAutorizacion(
    AutorizacionFactura autorizacion,
  ) async {
    final response = await _apiClient.dio.post(
      '/autorizacion_facturas',
      data: autorizacion.toJson(),
    );

    return AutorizacionFactura.fromJson(response.data);
  }

  Future<AutorizacionFactura> putAutorizacion(
    int id,
    AutorizacionFactura autorizacion,
  ) async {
    final response = await _apiClient.dio.put(
      '/autorizacion_facturas/$id',
      data: autorizacion.toJson(),
    );

    return AutorizacionFactura.fromJson(response.data);
  }

  Future<void> deleteAutorizacion(int id) async {
    await _apiClient.dio.delete('/autorizacion_facturas/$id');
  }
}
