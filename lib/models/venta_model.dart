import 'detalle_venta_model.dart';

class Venta {
  final int? idVenta;
  final int? idCliente;
  final int idUsuario;
  final String usuarioNombreFactura;
  final int idAutorizacion;
  final String numeroFactura;
  final int correlativo;
  final String caiFactura;
  final String rangoInicialFactura;
  final String rangoFinalFactura;
  final DateTime fechaLimiteEmisionFactura;
  final String empresaNombreFactura;
  final String? empresaRazonSocialFactura;
  final String? empresaRtnFactura;
  final String? empresaDireccionFactura;
  final String? empresaTelefonoFactura;
  final String? empresaCorreoFactura;
  final String? empresaLogoFactura;
  final String clienteNombreFactura;
  final String? clienteRtnFactura;
  final String? clienteDireccionFactura;
  final String? clienteTelefonoFactura;
  final String? clienteCorreoFactura;
  final String? ordenCompraExenta;
  final String? constanciaRegistroExonerados;
  final String? registroSag;
  final DateTime fechaVenta;
  final double subtotal;
  final double totalDescuentos;
  final double totalExento;
  final double totalExonerado;
  final double totalGravado15;
  final double totalGravado18;
  final double totalIsv15;
  final double totalIsv18;
  final double total;
  final String totalLetras;
  final bool estadoFactura;
  final String? metodoPago;
  final List<DetalleVenta> detalles;

  const Venta({
    this.idVenta,
    this.idCliente,
    required this.idUsuario,
    required this.usuarioNombreFactura,
    required this.idAutorizacion,
    required this.numeroFactura,
    required this.correlativo,
    required this.caiFactura,
    required this.rangoInicialFactura,
    required this.rangoFinalFactura,
    required this.fechaLimiteEmisionFactura,
    required this.empresaNombreFactura,
    this.empresaRazonSocialFactura,
    this.empresaRtnFactura,
    this.empresaDireccionFactura,
    this.empresaTelefonoFactura,
    this.empresaCorreoFactura,
    this.empresaLogoFactura,
    required this.clienteNombreFactura,
    this.clienteRtnFactura,
    this.clienteDireccionFactura,
    this.clienteTelefonoFactura,
    this.clienteCorreoFactura,
    this.ordenCompraExenta,
    this.constanciaRegistroExonerados,
    this.registroSag,
    required this.fechaVenta,
    required this.subtotal,
    this.totalDescuentos = 0.0,
    this.totalExento = 0.0,
    this.totalExonerado = 0.0,
    this.totalGravado15 = 0.0,
    this.totalGravado18 = 0.0,
    this.totalIsv15 = 0.0,
    this.totalIsv18 = 0.0,
    required this.total,
    required this.totalLetras,
    this.estadoFactura = true,
    this.metodoPago,
    this.detalles = const [],
  });

  factory Venta.fromJson(Map<String, dynamic> json) {
    return Venta(
      idVenta: json['id_venta'],
      idCliente: json['id_cliente'],
      idUsuario: json['id_usuario'],
      usuarioNombreFactura: json['usuario_nombre_factura'],
      idAutorizacion: json['id_autorizacion'],
      numeroFactura: json['numero_factura'],
      correlativo: json['correlativo'],
      caiFactura: json['cai_factura'],
      rangoInicialFactura: json['rango_inicial_factura'],
      rangoFinalFactura: json['rango_final_factura'],
      fechaLimiteEmisionFactura: DateTime.parse(
        json['fecha_limite_emision_factura'],
      ),
      empresaNombreFactura: json['empresa_nombre_factura'],
      empresaRazonSocialFactura: json['empresa_razon_social_factura'],
      empresaRtnFactura: json['empresa_rtn_factura'],
      empresaDireccionFactura: json['empresa_direccion_factura'],
      empresaTelefonoFactura: json['empresa_telefono_factura'],
      empresaCorreoFactura: json['empresa_correo_factura'],
      empresaLogoFactura: json['empresa_logo_factura'],
      clienteNombreFactura: json['cliente_nombre_factura'],
      clienteRtnFactura: json['cliente_rtn_factura'],
      clienteDireccionFactura: json['cliente_direccion_factura'],
      clienteTelefonoFactura: json['cliente_telefono_factura'],
      clienteCorreoFactura: json['cliente_correo_factura'],
      ordenCompraExenta: json['orden_compra_exenta'],
      constanciaRegistroExonerados: json['constancia_registro_exonerados'],
      registroSag: json['registro_sag'],
      fechaVenta: DateTime.parse(json['fecha_venta']),
      subtotal: _aDouble(json['subtotal']),
      totalDescuentos: _aDouble(json['total_descuentos']),
      totalExento: _aDouble(json['total_exento']),
      totalExonerado: _aDouble(json['total_exonerado']),
      totalGravado15: _aDouble(json['total_gravado_15']),
      totalGravado18: _aDouble(json['total_gravado_18']),
      totalIsv15: _aDouble(json['total_isv_15']),
      totalIsv18: _aDouble(json['total_isv_18']),
      total: _aDouble(json['total']),
      totalLetras: json['total_letras'],
      estadoFactura:
          json['estado_factura'] == 1 || json['estado_factura'] == true,
      metodoPago: json['metodo_pago'],
      detalles: (json['detalles'] as List<dynamic>? ?? const [])
          .map((detalle) => DetalleVenta.fromJson(detalle))
          .toList(),
    );
  }

  static double _aDouble(dynamic valor) {
    if (valor == null) return 0.0;
    if (valor is num) return valor.toDouble();
    return double.parse(valor.toString());
  }
}
