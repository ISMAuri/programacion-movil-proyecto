class AutorizacionFactura {
  final int idAutorizacion;
  final int idEmpresa;
  final String cai;
  final String establecimiento;
  final String puntoEmision;
  final String tipoDocumento;
  final int rangoInicial;
  final int rangoFinal;
  final int siguienteCorrelativo;
  final DateTime fechaAutorizacion;
  final DateTime fechaLimiteEmision;
  final bool estado;

  AutorizacionFactura({
    required this.idAutorizacion,
    required this.idEmpresa,
    required this.cai,
    required this.establecimiento,
    required this.puntoEmision,
    required this.tipoDocumento,
    required this.rangoInicial,
    required this.rangoFinal,
    required this.siguienteCorrelativo,
    required this.fechaAutorizacion,
    required this.fechaLimiteEmision,
    required this.estado,
  });

  factory AutorizacionFactura.fromJson(Map<String, dynamic> json) {
    return AutorizacionFactura(
      idAutorizacion: json['id_autorizacion'],
      idEmpresa: json['id_empresa'],
      cai: json['cai'],
      establecimiento: json['establecimiento'],
      puntoEmision: json['punto_emision'],
      tipoDocumento: json['tipo_documento'],
      rangoInicial: json['rango_inicial'],
      rangoFinal: json['rango_final'],
      siguienteCorrelativo: json['siguiente_correlativo'],
      fechaAutorizacion: DateTime.parse(json['fecha_autorizacion']),
      fechaLimiteEmision: DateTime.parse(json['fecha_limite_emision']),
      estado: json['estado'] == 1 || json['estado'] == true,
    );
  }

}
