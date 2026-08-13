class DetalleVenta {
  final int? idDetalleVenta;
  final int idVenta;
  final int idProducto;
  final String? productoCodigoFactura;
  final String productoNombreFactura;
  final String? productoDescripcionFactura;
  final String? productoUnidadMedidaFactura;
  final double productoTasaImpuestoFactura;
  final int cantidad;
  final double precioUnitario;
  final double descuento;
  final double subtotal;
  final double baseGravada;
  final double baseExenta;
  final double baseExonerada;
  final double montoImpuesto;

  const DetalleVenta({
    this.idDetalleVenta,
    required this.idVenta,
    required this.idProducto,
    this.productoCodigoFactura,
    required this.productoNombreFactura,
    this.productoDescripcionFactura,
    this.productoUnidadMedidaFactura,
    this.productoTasaImpuestoFactura = 0.0,
    required this.cantidad,
    required this.precioUnitario,
    this.descuento = 0.0,
    required this.subtotal,
    this.baseGravada = 0.0,
    this.baseExenta = 0.0,
    this.baseExonerada = 0.0,
    this.montoImpuesto = 0.0,
  });

  factory DetalleVenta.fromJson(Map<String, dynamic> json) {
    return DetalleVenta(
      idDetalleVenta: json['id_detalle_venta'],
      idVenta: json['id_venta'],
      idProducto: json['id_producto'],
      productoCodigoFactura: json['producto_codigo_factura'],
      productoNombreFactura: json['producto_nombre_factura'],
      productoDescripcionFactura: json['producto_descripcion_factura'],
      productoUnidadMedidaFactura: json['producto_unidad_medida_factura'],
      productoTasaImpuestoFactura:
          _aDouble(json['producto_tasa_impuesto_factura']),
      cantidad: json['cantidad'],
      precioUnitario: _aDouble(json['precio_unitario']),
      descuento: _aDouble(json['descuento']),
      subtotal: _aDouble(json['subtotal']),
      baseGravada: _aDouble(json['base_gravada']),
      baseExenta: _aDouble(json['base_exenta']),
      baseExonerada: _aDouble(json['base_exonerada']),
      montoImpuesto: _aDouble(json['monto_impuesto']),
    );
  }

  static double _aDouble(dynamic valor) {
    if (valor == null) return 0.0;
    if (valor is num) return valor.toDouble();
    return double.parse(valor.toString());
  }
}
