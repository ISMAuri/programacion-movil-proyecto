class MovimientoInventario {
  final int idMovimiento;
  final int idProducto;
  final int idUsuario;
  final String tipoMovimiento;
  final int cantidad;
  final DateTime fechaMovimiento;
  final String? motivo;

  MovimientoInventario({
    required this.idMovimiento,
    required this.idProducto,
    required this.idUsuario,
    required this.tipoMovimiento,
    required this.cantidad,
    required this.fechaMovimiento,
    this.motivo,
  });

  factory MovimientoInventario.fromJson(Map<String, dynamic> json) {
    return MovimientoInventario(
      idMovimiento: json['id_movimiento'],
      idProducto: json['id_producto'],
      idUsuario: json['id_usuario'],
      tipoMovimiento: json['tipo_movimiento'],
      cantidad: json['cantidad'],
      fechaMovimiento: DateTime.parse(json['fecha_movimiento']),
      motivo: json['motivo'],
    );
  }
}