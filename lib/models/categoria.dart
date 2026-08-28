// Categoria Nuevo

class Categoria {
  final int id;
  final String nombre;
  final String descripcion;
  final String icono;
  final bool activo;

  Categoria({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.icono,
    required this.activo,
  });

  factory Categoria.fromJson(Map<String, dynamic> json) {
    return Categoria(
      id: json['id'],
      nombre: json['nombre'],
      descripcion: json['descripcion'] ?? "",
      icono: json['icono'] ?? "",
      activo: json['activo'] ?? true,
    );
  }
}
