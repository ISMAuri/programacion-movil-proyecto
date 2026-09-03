import '../config/api_client.dart';
import '../models/venta.dart';
import '../models/crear_venta_request.dart';

class VentaService {
  final ApiClient _apiClient = ApiClient();

  Future<List<Venta>> getVentas() async {
    final response = await _apiClient.dio.get('/ventas');

    final List<dynamic> data = response.data;

    return data.map((json) => Venta.fromJson(json)).toList();
  }

  Future<Venta> getVenta(int id) async {
    final response = await _apiClient.dio.get('/ventas/$id');

    return Venta.fromJson(response.data);
  }

  Future<Venta> getVentaPorNumero(String numeroFactura) async {
    final response = await _apiClient.dio.get('/ventas/numero/$numeroFactura');

    return Venta.fromJson(response.data);
  }

  Future<Venta> postVenta(CrearVentaRequest venta) async {
    final response = await _apiClient.dio.post('/ventas', data: venta.toJson());

    return Venta.fromJson(response.data);
  }

  Future<Venta> actualizarRutaPdf(int idVenta, String rutaPdf) async {
    final response = await _apiClient.dio.patch(
      '/ventas/$idVenta/pdf',
      data: {'ruta_pdf_factura': rutaPdf},
    );

    return Venta.fromJson(response.data);
  }
}
