class Producto {
  final int? idProducto;
  final int idCategoria;
  final String categoria;
  final String nombreProducto;
  final String descripcion;
  final String codigoProducto;
  final double precioCompra;
  final double precioVenta;
  final int stockActual;
  final String unidadMedida;
  final double tasaImpuesto;
  final bool estado;

  const Producto({
    this.idProducto,
    required this.idCategoria,
    required this.categoria,
    required this.nombreProducto,
    required this.descripcion,
    required this.codigoProducto,
    required this.precioCompra,
    required this.precioVenta,
    required this.stockActual,
    required this.unidadMedida,
    required this.tasaImpuesto,
    required this.estado,
  });
  
  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      idProducto: json['id_producto'],
      idCategoria: json['id_categoria'],
      categoria: json['categoria'],
      nombreProducto: json['nombre_producto'],
      descripcion: json['descripcion'],
      codigoProducto: json['codigo_producto'],
      precioCompra: (json['precio_compra'] as num).toDouble(),
      precioVenta: (json['precio_venta'] as num).toDouble(),
      stockActual: json['stock_actual'],
      unidadMedida: json['unidad_medida'],
      tasaImpuesto: (json['tasa_impuesto'] as num).toDouble(),
      estado: json['estado'],
    );
  }
}
