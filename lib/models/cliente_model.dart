class Cliente {
  final int idCliente;
  final String nombreCliente;
  final String? rtn;
  final String? direccion;
  final String? telefono;
  final String? correo;
  final DateTime fechaRegistro;

  Cliente({
    required this.idCliente,
    required this.nombreCliente,
    this.rtn,
    this.direccion,
    this.telefono,
    this.correo,
    required this.fechaRegistro,
  });

  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      idCliente: json['id_cliente'],
      nombreCliente: json['nombre_cliente'],
      rtn: json['rtn'],
      direccion: json['direccion'],
      telefono: json['telefono'],
      correo: json['correo'],
      fechaRegistro: DateTime.parse(json['fecha_registro']),
    );
  }
}