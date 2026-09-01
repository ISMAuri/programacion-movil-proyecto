class DetalleVentaRequest {
  final int idProducto;
  final int cantidad;
  final double descuento;

  const DetalleVentaRequest({
    required this.idProducto,
    required this.cantidad,
    this.descuento = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'id_producto': idProducto,
      'cantidad': cantidad,
      'descuento': descuento,
    };
  }
}
