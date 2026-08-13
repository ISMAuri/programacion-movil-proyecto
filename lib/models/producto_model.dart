class Producto {
  final int? idProducto;
  final int idCategoria;
  final String nombreProducto;
  final String? descripcion;
  final String? rutaFoto;
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
    this.rutaFoto,
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
      nombreProducto: json['nombre_producto'],
      descripcion: json['descripcion'],
      rutaFoto: json['ruta_foto'],
      codigoProducto: json['codigo_producto'],
      precioCompra: (json['precio_compra'] as num?)?.toDouble(),
      precioVenta: (json['precio_venta'] as num).toDouble(),
      stockActual: json['stock_actual'] ?? 0,
      unidadMedida: json['unidad_medida'],
      tasaImpuesto: (json['tasa_impuesto'] as num?)?.toDouble() ?? 15.0,
      estado: json['estado'] == 1 || json['estado'] == true,
    );
  }
}
