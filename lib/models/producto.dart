import '../utils/json_utils.dart';

class Producto {
  final int? idProducto;
  final int idCategoria;
  final String nombreProducto;
  final String? descripcion;
  final String? codigoProducto;
  final double? precioCompra;
  final double precioVenta;
  final int stockActual;
  final String? unidadMedida;
  final double tasaImpuesto;
  final bool estado;

  const Producto({
    this.idProducto,
    required this.idCategoria,
    required this.nombreProducto,
    this.descripcion,
    this.codigoProducto,
    this.precioCompra,
    required this.precioVenta,
    this.stockActual = 0,
    this.unidadMedida,
    this.tasaImpuesto = 15.0,
    this.estado = true,
  });

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      idProducto: json['id_producto'],
      idCategoria: json['id_categoria'],
      nombreProducto: json['nombre_producto'] ?? '',
      descripcion: json['descripcion'],
      codigoProducto: json['codigo_producto'],
      precioCompra: jsonToNullableDouble(json['precio_compra']),
      precioVenta: jsonToDouble(json['precio_venta']),
      stockActual: json['stock_actual'] ?? 0,
      unidadMedida: json['unidad_medida'],
      tasaImpuesto: jsonToDouble(json['tasa_impuesto']),
      estado: jsonToBool(json['estado']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_categoria': idCategoria,
      'nombre_producto': nombreProducto,
      'descripcion': descripcion,
      'codigo_producto': codigoProducto,
      'precio_compra': precioCompra,
      'precio_venta': precioVenta,
      'stock_actual': stockActual,
      'unidad_medida': unidadMedida,
      'tasa_impuesto': tasaImpuesto,
      'estado': estado,
    };
  }
}
