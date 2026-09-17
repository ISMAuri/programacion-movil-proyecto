import '../utils/json_utils.dart';

class AutorizacionFactura {
  final int? idAutorizacion;
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

  const AutorizacionFactura({
    this.idAutorizacion,
    required this.idEmpresa,
    required this.cai,
    required this.establecimiento,
    required this.puntoEmision,
    this.tipoDocumento = '01',
    required this.rangoInicial,
    required this.rangoFinal,
    this.siguienteCorrelativo = 1,
    required this.fechaAutorizacion,
    required this.fechaLimiteEmision,
    this.estado = true,
  });

  factory AutorizacionFactura.fromJson(Map<String, dynamic> json) {
    return AutorizacionFactura(
      idAutorizacion: json['id_autorizacion'],
      idEmpresa: json['id_empresa'],
      cai: json['cai'] ?? '',
      establecimiento: json['establecimiento'] ?? '',
      puntoEmision: json['punto_emision'] ?? '',
      tipoDocumento: json['tipo_documento'] ?? '01',
      rangoInicial: json['rango_inicial'],
      rangoFinal: json['rango_final'],
      siguienteCorrelativo: json['siguiente_correlativo'] ?? 1,
      fechaAutorizacion: DateTime.parse(json['fecha_autorizacion']),
      fechaLimiteEmision: DateTime.parse(json['fecha_limite_emision']),
      estado: jsonToBool(json['estado']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_empresa': idEmpresa,
      'cai': cai,
      'establecimiento': establecimiento,
      'punto_emision': puntoEmision,
      'tipo_documento': tipoDocumento,
      'rango_inicial': rangoInicial,
      'rango_final': rangoFinal,
      'siguiente_correlativo': siguienteCorrelativo,
      'fecha_autorizacion': fechaAutorizacion
          .toIso8601String()
          .split('T')
          .first,
      'fecha_limite_emision': fechaLimiteEmision
          .toIso8601String()
          .split('T')
          .first,
      'estado': estado,
    };
  }
}
