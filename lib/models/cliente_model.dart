class Cliente {
  final int? idCliente;
  final String nombreCliente;
  final String rtn;
  final String direccion;
  final String telefono;
  final String correo;
  final DateTime fechaRegistro;
  final bool estado;

  const Cliente({
    this.idCliente,
    required this.nombreCliente,
    required this.rtn,
    required this.direccion,
    required this.telefono,
    required this.correo,
    required this.fechaRegistro,
    required this.estado,
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
      estado: json['estado'],
    );
  }
}
