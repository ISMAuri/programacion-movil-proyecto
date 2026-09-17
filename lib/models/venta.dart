import '../utils/json_utils.dart';

class Venta {
  final int idVenta;

  final int? idCliente;
  final int idUsuario;
  final int idAutorizacion;

  final String usuarioNombreFactura;

  final String numeroFactura;
  final int correlativo;

  final String caiFactura;
  final String rangoInicialFactura;
  final String rangoFinalFactura;
  final DateTime fechaAutorizacionFactura;
  final DateTime fechaLimiteEmisionFactura;

  final String empresaNombreFactura;
  final String? empresaRazonSocialFactura;
  final String? empresaRtnFactura;
  final String empresaDireccionFactura;
  final String? empresaTelefonoFactura;
  final String? empresaCorreoFactura;
  final String? empresaLogoFactura;

  final String clienteNombreFactura;
  final String? clienteTipoDocumentoFactura;
  final String? clienteNumeroDocumentoFactura;
  final String? clienteRtnFactura;
  final String? clienteDireccionFactura;
  final String? clienteTelefonoFactura;
  final String? clienteCorreoFactura;

  final String? ordenCompraExenta;
  final String? constanciaRegistroExonerados;
  final String? registroSag;

  final DateTime fechaVenta;

  final String moneda;
  final double tasaCambio;

  final double subtotal;
  final double totalDescuentos;
  final double totalExento;
  final double totalExonerado;
  final double totalTasaCero;
  final double totalGravado15;
  final double totalGravado18;
  final double totalIsv15;
  final double totalIsv18;
  final double total;

  final String totalLetras;

  final bool estadoFactura;
  final String? metodoPago;
  final String? rutaPdfFactura;

  const Venta({
    required this.idVenta,
    this.idCliente,
    required this.idUsuario,
    required this.idAutorizacion,
    required this.usuarioNombreFactura,
    required this.numeroFactura,
    required this.correlativo,
    required this.caiFactura,
    required this.rangoInicialFactura,
    required this.rangoFinalFactura,
    required this.fechaAutorizacionFactura,
    required this.fechaLimiteEmisionFactura,
    required this.empresaNombreFactura,
    this.empresaRazonSocialFactura,
    this.empresaRtnFactura,
    required this.empresaDireccionFactura,
    this.empresaTelefonoFactura,
    this.empresaCorreoFactura,
    this.empresaLogoFactura,
    required this.clienteNombreFactura,
    this.clienteTipoDocumentoFactura,
    this.clienteNumeroDocumentoFactura,
    this.clienteRtnFactura,
    this.clienteDireccionFactura,
    this.clienteTelefonoFactura,
    this.clienteCorreoFactura,
    this.ordenCompraExenta,
    this.constanciaRegistroExonerados,
    this.registroSag,
    required this.fechaVenta,
    required this.moneda,
    required this.tasaCambio,
    required this.subtotal,
    required this.totalDescuentos,
    required this.totalExento,
    required this.totalExonerado,
    required this.totalTasaCero,
    required this.totalGravado15,
    required this.totalGravado18,
    required this.totalIsv15,
    required this.totalIsv18,
    required this.total,
    required this.totalLetras,
    required this.estadoFactura,
    this.metodoPago,
    this.rutaPdfFactura,
  });

  factory Venta.fromJson(Map<String, dynamic> json) {
    return Venta(
      idVenta: json['id_venta'],
      idCliente: json['id_cliente'],
      idUsuario: json['id_usuario'],
      idAutorizacion: json['id_autorizacion'],

      usuarioNombreFactura: json['usuario_nombre_factura'] ?? '',

      numeroFactura: json['numero_factura'] ?? '',
      correlativo: json['correlativo'],

      caiFactura: json['cai_factura'] ?? '',
      rangoInicialFactura: json['rango_inicial_factura'] ?? '',
      rangoFinalFactura: json['rango_final_factura'] ?? '',
      fechaAutorizacionFactura: DateTime.parse(
        json['fecha_autorizacion_factura'],
      ),
      fechaLimiteEmisionFactura: DateTime.parse(
        json['fecha_limite_emision_factura'],
      ),

      empresaNombreFactura: json['empresa_nombre_factura'] ?? '',
      empresaRazonSocialFactura: json['empresa_razon_social_factura'],
      empresaRtnFactura: json['empresa_rtn_factura'] ?? '',
      empresaDireccionFactura: json['empresa_direccion_factura'] ?? '',
      empresaTelefonoFactura: json['empresa_telefono_factura'],
      empresaCorreoFactura: json['empresa_correo_factura'],
      empresaLogoFactura: json['empresa_logo_factura'],

      clienteNombreFactura: json['cliente_nombre_factura'] ?? '',
      clienteTipoDocumentoFactura: json['cliente_tipo_documento_factura'],
      clienteNumeroDocumentoFactura: json['cliente_numero_documento_factura'],
      clienteRtnFactura: json['cliente_rtn_factura'],
      clienteDireccionFactura: json['cliente_direccion_factura'],
      clienteTelefonoFactura: json['cliente_telefono_factura'],
      clienteCorreoFactura: json['cliente_correo_factura'],

      ordenCompraExenta: json['orden_compra_exenta'],
      constanciaRegistroExonerados: json['constancia_registro_exonerados'],
      registroSag: json['registro_sag'],

      fechaVenta: DateTime.parse(json['fecha_venta']),

      moneda: json['moneda'] ?? 'HNL',
      tasaCambio: jsonToDouble(json['tasa_cambio']),

      subtotal: jsonToDouble(json['subtotal']),
      totalDescuentos: jsonToDouble(json['total_descuentos']),
      totalExento: jsonToDouble(json['total_exento']),
      totalExonerado: jsonToDouble(json['total_exonerado']),
      totalTasaCero: jsonToDouble(json['total_tasa_cero']),
      totalGravado15: jsonToDouble(json['total_gravado_15']),
      totalGravado18: jsonToDouble(json['total_gravado_18']),
      totalIsv15: jsonToDouble(json['total_isv_15']),
      totalIsv18: jsonToDouble(json['total_isv_18']),
      total: jsonToDouble(json['total']),

      totalLetras: json['total_letras'] ?? '',

      estadoFactura: jsonToBool(json['estado_factura']),
      metodoPago: json['metodo_pago'],
      rutaPdfFactura: json['ruta_pdf_factura'],
    );
  }
}
