import 'detalle_venta_model.dart';
class Venta {
  final int? idVenta;
  final int idCliente;
  final String nombreCliente;
  final String numeroFactura;
  final DateTime fechaVenta;
  final String metodoPago;
  final String estadoPago;
  final double subtotal;
  final double impuesto;
  final double total;
  final List<DetalleVenta> detalles;
  final bool estado;

  const Venta({
    this.idVenta,
    required this.idCliente,
    required this.nombreCliente,
    required this.numeroFactura,
    required this.fechaVenta,
    required this.metodoPago,
    required this.estadoPago,
    required this.subtotal,
    required this.impuesto,
    required this.total,
    required this.detalles,
    required this.estado,
  });
}
