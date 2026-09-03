import '../config/api_client.dart';
import '../models/empresa.dart';

class EmpresaService {
  final ApiClient _apiClient = ApiClient();

  Future<List<Empresa>> getEmpresas() async {
    final response = await _apiClient.dio.get('/empresas');

    final List<dynamic> data = response.data;

    return data.map((json) => Empresa.fromJson(json)).toList();
  }

  Future<Empresa> getEmpresa(int id) async {
    final response = await _apiClient.dio.get('/empresas/$id');

    return Empresa.fromJson(response.data);
  }

  Future<Empresa> postEmpresa(Empresa empresa) async {
    final response = await _apiClient.dio.post(
      '/empresas',
      data: empresa.toJson(),
    );

    return Empresa.fromJson(response.data);
  }

  Future<Empresa> putEmpresa(int id, Empresa empresa) async {
    final response = await _apiClient.dio.put(
      '/empresas/$id',
      data: empresa.toJson(),
    );

    return Empresa.fromJson(response.data);
  }
}
