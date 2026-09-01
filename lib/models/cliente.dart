import '../utils/json_utils.dart';

class Cliente {
  final int? idCliente;
  final String nombreCliente;
  final String? rtn;
  final String? direccion;
  final String? telefono;
  final String? correo;
  final DateTime? fechaRegistro;
  final bool estado;

  const Cliente({
    this.idCliente,
    required this.nombreCliente,
    this.rtn,
    this.direccion,
    this.telefono,
    this.correo,
    this.fechaRegistro,
    this.estado = true,
  });

  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      idCliente: json['id_cliente'],
      nombreCliente: json['nombre_cliente'] ?? '',
      rtn: json['rtn'],
      direccion: json['direccion'],
      telefono: json['telefono'],
      correo: json['correo'],
      fechaRegistro: json['fecha_registro'] != null
          ? DateTime.parse(json['fecha_registro'])
          : null,
      estado: jsonToBool(json['estado']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre_cliente': nombreCliente,
      'rtn': rtn,
      'direccion': direccion,
      'telefono': telefono,
      'correo': correo,
      'estado': estado,
    };
  }
}