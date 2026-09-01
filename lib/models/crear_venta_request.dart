import 'detalle_venta_request.dart';

class CrearVentaRequest {
  final int? idCliente;
  final int idUsuario;
  final int idAutorizacion;
  final List<DetalleVentaRequest> detalles;

  final String? metodoPago;

  final String? ordenCompraExenta;
  final String? constanciaRegistroExonerados;
  final String? registroSag;

  final String totalLetras;

  const CrearVentaRequest({
    this.idCliente,
    required this.idUsuario,
    required this.idAutorizacion,
    required this.detalles,
    this.metodoPago,
    this.ordenCompraExenta,
    this.constanciaRegistroExonerados,
    this.registroSag,
    required this.totalLetras,
  });

  Map<String, dynamic> toJson() {
    return {
      'id_cliente': idCliente,
      'id_usuario': idUsuario,
      'id_autorizacion': idAutorizacion,
      'detalles': detalles.map((detalle) => detalle.toJson()).toList(),
      'metodo_pago': metodoPago,
      'orden_compra_exenta': ordenCompraExenta,
      'constancia_registro_exonerados': constanciaRegistroExonerados,
      'registro_sag': registroSag,
      'total_letras': totalLetras,
    };
  }
}
