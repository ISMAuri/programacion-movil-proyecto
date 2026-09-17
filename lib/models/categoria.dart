import '../utils/json_utils.dart';
class Categoria {
  final int? id;
  final String nombre;
  final String? descripcion;
  final String? icono;
  final bool activo;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Categoria({
    this.id,
    required this.nombre,
    this.descripcion,
    this.icono,
    this.activo = true,
    this.createdAt,
    this.updatedAt,
  });

  factory Categoria.fromJson(Map<String, dynamic> json) {
    return Categoria(
      id: json['id'],
      nombre: json['nombre'] ?? '',
      descripcion: json['descripcion'],
      icono: json['icono'],
      activo: jsonToBool(json['activo']),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'descripcion': descripcion,
      'icono': icono,
      'activo': activo,
    };
  }
}