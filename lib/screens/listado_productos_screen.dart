import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../config/app_text_styles.dart';
import 'formulario_producto_screen.dart';

class _ProductoDemo {
  const _ProductoDemo({
    required this.icono,
    required this.nombre,
    required this.categoria,
    required this.descripcion,
    required this.codigo,
    required this.precioCompra,
    required this.precioVenta,
    required this.stock,
    required this.unidadMedida,
    required this.tasaImpuesto,
    required this.activo,
  });

  final IconData icono;
  final String nombre;
  final String categoria;
  final String descripcion;
  final String codigo;
  final double precioCompra;
  final double precioVenta;
  final int stock;
  final String unidadMedida;
  final double tasaImpuesto;
  final bool activo;
}

const List<_ProductoDemo> _productos = [
  _ProductoDemo(
    icono: Icons.local_drink_outlined,
    nombre: "Leche Entera 1L",
    categoria: "Lácteos",
    descripcion: "Leche entera en presentación de un litro",
    codigo: "LAC-001",
    precioCompra: 48.00,
    precioVenta: 60.59,
    stock: 26,
    unidadMedida: "Unidad",
    tasaImpuesto: 15.0,
    activo: true,
  ),
  _ProductoDemo(
    icono: Icons.rice_bowl_outlined,
    nombre: "Arroz 2 lbs",
    categoria: "Cereales",
    descripcion: "Arroz blanco en bolsa de dos libras",
    codigo: "CER-001",
    precioCompra: 24.00,
    precioVenta: 30.00,
    stock: 52,
    unidadMedida: "Paquete",
    tasaImpuesto: 0.0,
    activo: true,
  ),
  _ProductoDemo(
    icono: Icons.egg_outlined,
    nombre: "Huevos Docena",
    categoria: "Proteínas",
    descripcion: "Cartón con doce huevos",
    codigo: "PRO-001",
    precioCompra: 36.00,
    precioVenta: 45.00,
    stock: 5,
    unidadMedida: "Unidad",
    tasaImpuesto: 0.0,
    activo: true,
  ),
  _ProductoDemo(
    icono: Icons.wine_bar_outlined,
    nombre: "Vino Tinto 750ml",
    categoria: "Bebidas",
    descripcion: "Botella de vino tinto de 750 mililitros",
    codigo: "BEB-001",
    precioCompra: 95.00,
    precioVenta: 120.00,
    stock: 9,
    unidadMedida: "Unidad",
    tasaImpuesto: 18.0,
    activo: true,
  ),
  _ProductoDemo(
    icono: Icons.cookie_outlined,
    nombre: "Galletas de Chocolate Pack de 6",
    categoria: "Postres",
    descripcion: "Paquete con seis galletas de chocolate",
    codigo: "POS-001",
    precioCompra: 27.00,
    precioVenta: 35.00,
    stock: 15,
    unidadMedida: "Paquete",
    tasaImpuesto: 15.0,
    activo: true,
  ),
];

class ListadoProductosScreen extends StatefulWidget {
  const ListadoProductosScreen({super.key});

  @override
  State<ListadoProductosScreen> createState() => _ListadoProductosScreenState();
}

class _ListadoProductosScreenState extends State<ListadoProductosScreen> {
  String _busqueda = "";

  List<_ProductoDemo> get _productosFiltrados {
    final texto = _busqueda.toLowerCase().trim();
    if (texto.isEmpty) return _productos;

    return _productos.where((producto) {
      return producto.nombre.toLowerCase().contains(texto) ||
          producto.categoria.toLowerCase().contains(texto) ||
          producto.codigo.toLowerCase().contains(texto);
    }).toList();
  }

  void _abrirFormulario([_ProductoDemo? producto]) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FormularioProductoScreen(
          categoria: producto?.categoria,
          nombreProducto: producto?.nombre,
          descripcion: producto?.descripcion,
          codigoProducto: producto?.codigo,
          precioCompra: producto?.precioCompra,
          precioVenta: producto?.precioVenta,
          stockActual: producto?.stock,
          unidadMedida: producto?.unidadMedida,
          tasaImpuesto: producto?.tasaImpuesto,
          activo: producto?.activo,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final productos = _productosFiltrados;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Productos", style: AppTextStyles.screenTitle),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
      ),
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 46,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: TextField(
                      onChanged: (valor) => setState(() => _busqueda = valor),
                      decoration: const InputDecoration(
                        hintText: "Buscar por nombre, código o categoría...",
                        prefixIcon: Icon(Icons.search),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: productos.isEmpty
                ? const Center(child: Text("No se encontraron productos"))
                : ListView.builder(
                    itemCount: productos.length,
                    itemBuilder: (context, index) {
                      final producto = productos[index];

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        color: AppColors.white,
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: InkWell(
                          onTap: () => _abrirFormulario(producto),
                          child: Padding(
                            padding: const EdgeInsets.all(14),
                            child: Row(
                              children: [
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: AppColors.background,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    producto.icono,
                                    color: AppColors.primary,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        producto.nombre,
                                        style: AppTextStyles.cardTitle,
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        producto.categoria,
                                        style: AppTextStyles.subtitle,
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        "Stock: ${producto.stock}",
                                        style: AppTextStyles.subtitle.copyWith(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: producto.stock > 10
                                              ? AppColors.success
                                              : AppColors.warning,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      "L. ${producto.precioVenta.toStringAsFixed(2)}",
                                      style: AppTextStyles.cardTitle.copyWith(
                                        color: AppColors.success,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    const Icon(
                                      Icons.chevron_right,
                                      color: AppColors.disabled,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _abrirFormulario(),
        backgroundColor: AppColors.secondary,
        foregroundColor: AppColors.white,
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
