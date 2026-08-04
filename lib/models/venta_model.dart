class Venta {
  final int idVenta;
  final int idCliente;
  final int idUsuario;
  final int idAutorizacion;
  final String numeroFactura;
  final DateTime fechaVenta;
  final double subtotal;
  final double impuesto;
  final double total;
  final String? estadoPago;
  final String? metodoPago;

  Venta({
    required this.idVenta,
    required this.idCliente,
    required this.idUsuario,
    required this.idAutorizacion,
    required this.numeroFactura,
    required this.fechaVenta,
    required this.subtotal,
    required this.impuesto,
    required this.total,
    this.estadoPago,
    this.metodoPago,
  });

  factory Venta.fromJson(Map<String, dynamic> json) {
    return Venta(
      idVenta: json['id_venta'],
      idCliente: json['id_cliente'],
      idUsuario: json['id_usuario'],
      idAutorizacion: json['id_autorizacion'],
      numeroFactura: json['numero_factura'],
      fechaVenta: DateTime.parse(json['fecha_venta']),
      subtotal: json['subtotal'].toDouble(),
      impuesto: json['impuesto'].toDouble(),
      total: json['total'].toDouble(),
      estadoPago: json['estado_pago'],
      metodoPago: json['metodo_pago'],
    );
  }
}