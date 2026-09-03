import '../config/api_client.dart';
import '../models/cliente.dart';

class ClienteService {
  final ApiClient _apiClient = ApiClient();

  Future<List<Cliente>> getClientes({bool soloActivos = true}) async {
    final response = await _apiClient.dio.get(
      '/clientes',
      queryParameters: soloActivos ? {'estado': true} : null,
    );

    final List<dynamic> data = response.data;

    return data.map((json) => Cliente.fromJson(json)).toList();
  }

  Future<Cliente> getCliente(int id) async {
    final response = await _apiClient.dio.get('/clientes/$id');

    return Cliente.fromJson(response.data);
  }

  Future<Cliente> postCliente(Cliente cliente) async {
    final response = await _apiClient.dio.post(
      '/clientes',
      data: cliente.toJson(),
    );

    return Cliente.fromJson(response.data);
  }

  Future<Cliente> putCliente(int id, Cliente cliente) async {
    final response = await _apiClient.dio.put(
      '/clientes/$id',
      data: cliente.toJson(),
    );

    return Cliente.fromJson(response.data);
  }

  Future<void> deleteCliente(int id) async {
    await _apiClient.dio.delete('/clientes/$id');
  }
}
