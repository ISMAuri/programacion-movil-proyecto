import '../utils/json_utils.dart';

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
  final double baseTasaCero;
  final double montoImpuesto;

  const DetalleVenta({
    this.idDetalleVenta,
    required this.idVenta,
    required this.idProducto,
    this.productoCodigoFactura,
    required this.productoNombreFactura,
    this.productoDescripcionFactura,
    this.productoUnidadMedidaFactura,
    required this.productoTasaImpuestoFactura,
    required this.cantidad,
    required this.precioUnitario,
    required this.descuento,
    required this.subtotal,
    required this.baseGravada,
    required this.baseExenta,
    required this.baseExonerada,
    required this.baseTasaCero,
    required this.montoImpuesto,
  });

  factory DetalleVenta.fromJson(Map<String, dynamic> json) {
    return DetalleVenta(
      idDetalleVenta: json['id_detalle_venta'],
      idVenta: json['id_venta'],
      idProducto: json['id_producto'],
      productoCodigoFactura: json['producto_codigo_factura'],
      productoNombreFactura: json['producto_nombre_factura'] ?? '',
      productoDescripcionFactura: json['producto_descripcion_factura'],
      productoUnidadMedidaFactura: json['producto_unidad_medida_factura'],
      productoTasaImpuestoFactura: jsonToDouble(
        json['producto_tasa_impuesto_factura'],
      ),
      cantidad: json['cantidad'],
      precioUnitario: jsonToDouble(json['precio_unitario']),
      descuento: jsonToDouble(json['descuento']),
      subtotal: jsonToDouble(json['subtotal']),
      baseGravada: jsonToDouble(json['base_gravada']),
      baseExenta: jsonToDouble(json['base_exenta']),
      baseExonerada: jsonToDouble(json['base_exonerada']),
      baseTasaCero: jsonToDouble(json['base_tasa_cero']),
      montoImpuesto: jsonToDouble(json['monto_impuesto']),
    );
  }
}
