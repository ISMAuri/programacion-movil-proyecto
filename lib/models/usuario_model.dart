// Modelo de Usuario Anterior

class Usuario {
  final int idUsuario;
  final int idEmpresa;
  final String nombreUsuario;
  final String correo;
  final bool estado;
  final DateTime fechaRegistro;

  Usuario({
    required this.idUsuario,
    required this.idEmpresa,
    required this.nombreUsuario,
    required this.correo,
    required this.estado,
    required this.fechaRegistro,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      idUsuario: json['id_usuario'],
      idEmpresa: json['id_empresa'],
      nombreUsuario: json['nombre_usuario'],
      correo: json['correo'],
      estado: json['estado'],
      fechaRegistro: DateTime.parse(json['fecha_registro']),
    );
  }
}