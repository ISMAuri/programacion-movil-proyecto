import '../config/api_client.dart';
import '../models/autorizacion_factura.dart';

class AutorizacionFacturaService {
  final ApiClient _apiClient = ApiClient();

  // obtiene todas las autorizaciones
  Future<List<AutorizacionFactura>> getAutorizaciones() async {
    final response = await _apiClient.dio.get('/autorizacion-facturas');

    final List<dynamic> data = response.data;

    return data.map((json) => AutorizacionFactura.fromJson(json)).toList();
  }

  // obtiene una autorizacion por su id
  Future<AutorizacionFactura> getAutorizacion(int id) async {
    final response = await _apiClient.dio.get('/autorizacion-facturas/$id');

    return AutorizacionFactura.fromJson(response.data);
  }

  // Obtiene la única autorización activa de la empresa.
  Future<AutorizacionFactura> getAutorizacionActivaEmpresa(
    int idEmpresa,
  ) async {
    final response = await _apiClient.dio.get(
      '/autorizacion-facturas/empresa/$idEmpresa/activa',
    );

    return AutorizacionFactura.fromJson(response.data);
  }

  // Obtiene el historial, o sea las autorizaciones inactivas de la empresa
  Future<List<AutorizacionFactura>> getAutorizacionesAnterioresEmpresa(
    int idEmpresa,
  ) async {
    final response = await _apiClient.dio.get(
      '/autorizacion-facturas',
      queryParameters: {'estado': false, 'id_empresa': idEmpresa},
    );

    final List<dynamic> data = response.data;

    return data.map((json) => AutorizacionFactura.fromJson(json)).toList();
  }

  // Crea una nueva autorizacion
  // El backend se encarga de desactivar la anterior
  // y dejar esta nueva como activa.
  Future<AutorizacionFactura> postAutorizacion(
    AutorizacionFactura autorizacion,
  ) async {
    final response = await _apiClient.dio.post(
      '/autorizacion-facturas',
      data: autorizacion.toJson(),
    );

    return AutorizacionFactura.fromJson(response.data);
  }

  // dorrige datos de una autorizacion existente
  Future<AutorizacionFactura> putAutorizacion(
    int id,
    AutorizacionFactura autorizacion,
  ) async {
    final response = await _apiClient.dio.put(
      '/autorizacion-facturas/$id',
      data: autorizacion.toJson(),
    );

    return AutorizacionFactura.fromJson(response.data);
  }

  // Desactiva una autorizacion
  Future<void> deleteAutorizacion(int id) async {
    await _apiClient.dio.delete('/autorizacion-facturas/$id');
  }
}
