class DetalleVenta {
  final int? idDetalleVenta;
  final int idProducto;
  final String nombreProducto;
  final int cantidad;
  final double precioUnitario;
  final double tasaImpuesto;
  final double subtotal;

  const DetalleVenta({
    this.idDetalleVenta,
    required this.idProducto,
    required this.nombreProducto,
    required this.cantidad,
    required this.precioUnitario,
    required this.tasaImpuesto,
    required this.subtotal,
  });
}