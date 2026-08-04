class DetalleVenta {
  final int idDetalleVenta;
  final int idVenta;
  final int idProducto;
  final int cantidad;
  final double precioUnitario;
  final double subtotal;

  DetalleVenta({
    required this.idDetalleVenta,
    required this.idVenta,
    required this.idProducto,
    required this.cantidad,
    required this.precioUnitario,
    required this.subtotal,
  });

  factory DetalleVenta.fromJson(Map<String, dynamic> json) {
    return DetalleVenta(
      idDetalleVenta: json['id_detalle_venta'],
      idVenta: json['id_venta'],
      idProducto: json['id_producto'],
      cantidad: json['cantidad'],
      precioUnitario: json['precio_unitario'].toDouble(),
      subtotal: json['subtotal'].toDouble(),
    );
  }
}