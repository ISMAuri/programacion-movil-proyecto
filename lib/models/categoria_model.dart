class Categoria {
  final int idCategoria;
  final String nombreCategoria;
  final String? descripcion;
  final bool estado;

  const Categoria({
    required this.idCategoria,
    required this.nombreCategoria,
    required this.descripcion,
    required this.estado,
  });

  factory Categoria.fromJson(Map<String, dynamic> json) {
    return Categoria(
      idCategoria: json['id_categoria'],
      nombreCategoria: json['nombre_categoria'],
      descripcion: json['descripcion'],
      estado: json['estado'] == 1 || json['estado'] == true,
    );
  }
}
