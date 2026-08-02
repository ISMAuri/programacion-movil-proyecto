class Producto {
  String nombre;
  String codigo;
  String categoria;
  double precio;
  int cantidad;

  Producto({
    required this.nombre,
    required this.codigo,
    required this.categoria,
    required this.precio,
    required this.cantidad,
  });

  // para aumentar inventario
  void agregarStock(int cantidadNueva) {
    cantidad += cantidadNueva;
  }

  // para reducir inventario
  bool venderProducto(int cantidadVendida) {
    if (cantidadVendida <= cantidad) {
      cantidad -= cantidadVendida;
      return true;
    }
    return false;
  }
}

