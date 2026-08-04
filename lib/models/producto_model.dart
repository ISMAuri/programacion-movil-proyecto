class Producto {
  final int idProducto;
  final int idCategoria;
  final String nombreProducto;
  final String? descripcion;
  final String? codigoProducto;
  final double? precioCompra;
  final double precioVenta;
  final int stockActual;
  final String? unidadMedida;
  final bool estado;

  Producto({
    required this.idProducto,
    required this.idCategoria,
    required this.nombreProducto,
    this.descripcion,
    this.codigoProducto,
    this.precioCompra,
    required this.precioVenta,
    required this.stockActual,
    this.unidadMedida,
    required this.estado,
  });

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      idProducto: json['id_producto'],
      idCategoria: json['id_categoria'],
      nombreProducto: json['nombre_producto'],
      descripcion: json['descripcion'],
      codigoProducto: json['codigo_producto'],
      precioCompra: json['precio_compra']?.toDouble(),
      precioVenta: json['precio_venta'].toDouble(),
      stockActual: json['stock_actual'],
      unidadMedida: json['unidad_medida'],
      estado: json['estado'],
    );
  }
}