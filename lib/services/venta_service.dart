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

  Future<Venta> anularVenta(int id) async {
    final response = await _apiClient.dio.put('/ventas/$id/anular');

    return Venta.fromJson(response.data['venta']);
  }

  Future<void> descargarFactura(int idVenta, String rutaDestino) async {
    await _apiClient.dio.download('/ventas/$idVenta/pdf', rutaDestino);
  }
}
