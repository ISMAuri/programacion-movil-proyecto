class MovimientoInventario {
  final int? idMovimiento;
  final int idProducto;
  final int idUsuario;
  final TipoMovimiento tipoMovimiento;
  final int cantidad;
  final DateTime? fechaMovimiento;
  final String? motivo;

  const MovimientoInventario({
    this.idMovimiento,
    required this.idProducto,
    required this.idUsuario,
    required this.tipoMovimiento,
    required this.cantidad,
    this.fechaMovimiento,
    this.motivo,
  });

  factory MovimientoInventario.fromJson(
    Map<String, dynamic> json,
  ) {
    return MovimientoInventario(
      idMovimiento: json['id_movimiento'],
      idProducto: json['id_producto'],
      idUsuario: json['id_usuario'],
      tipoMovimiento:
          json['tipo_movimiento'] == 'salida'
              ? TipoMovimiento.salida
              : TipoMovimiento.entrada,
      cantidad: json['cantidad'],
      fechaMovimiento:
          json['fecha_movimiento'] != null
              ? DateTime.parse(json['fecha_movimiento'])
              : null,
      motivo: json['motivo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_producto': idProducto,
      'id_usuario': idUsuario,
      'tipo_movimiento': tipoMovimiento.name,
      'cantidad': cantidad,
      'motivo': motivo,
    };
  }
}
enum TipoMovimiento {
  entrada,
  salida,
}