class Empresa {
  final int idEmpresa;
  final String nombreEmpresa;
  final String? razonSocial;
  final String? rtn;
  final String? direccion;
  final String? telefono;
  final String? correo;
  final String? logo;

  Empresa({
    required this.idEmpresa,
    required this.nombreEmpresa,
    this.razonSocial,
    this.rtn,
    this.direccion,
    this.telefono,
    this.correo,
    this.logo,
  });

  factory Empresa.fromJson(Map<String, dynamic> json) {
    return Empresa(
      idEmpresa: json['id_empresa'],
      nombreEmpresa: json['nombre_empresa'],
      razonSocial: json['razon_social'],
      rtn: json['rtn'],
      direccion: json['direccion'],
      telefono: json['telefono'],
      correo: json['correo'],
      logo: json['logo'],
    );
  }
}