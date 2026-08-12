import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../config/app_text_styles.dart';
import '../models/producto_model.dart';

const List<Producto> _productos = [
  Producto(
    idProducto: 1,
    idCategoria: 1,
    categoria: "Lácteos",
    nombreProducto: "Leche Entera 1L",
    descripcion: "Leche entera en presentación de un litro",
    codigoProducto: "LAC-001",
    precioCompra: 48.00,
    precioVenta: 60.59,
    stockActual: 26,
    unidadMedida: "Unidad",
    tasaImpuesto: 15.0,
    estado: true,
  ),
  Producto(
    idProducto: 2,
    idCategoria: 2,
    categoria: "Cereales",
    nombreProducto: "Arroz 2 lbs",
    descripcion: "Arroz blanco en bolsa de dos libras",
    codigoProducto: "CER-001",
    precioCompra: 24.00,
    precioVenta: 30.00,
    stockActual: 52,
    unidadMedida: "Paquete",
    tasaImpuesto: 0.0,
    estado: true,
  ),
  Producto(
    idProducto: 3,
    idCategoria: 3,
    categoria: "Proteínas",
    nombreProducto: "Huevos Docena",
    descripcion: "Cartón con doce huevos",
    codigoProducto: "PRO-001",
    precioCompra: 36.00,
    precioVenta: 45.00,
    stockActual: 5,
    unidadMedida: "Unidad",
    tasaImpuesto: 0.0,
    estado: true,
  ),
  Producto(
    idProducto: 4,
    idCategoria: 4,
    categoria: "Bebidas",
    nombreProducto: "Vino Tinto 750ml",
    descripcion: "Botella de vino tinto de 750 mililitros",
    codigoProducto: "BEB-001",
    precioCompra: 95.00,
    precioVenta: 120.00,
    stockActual: 9,
    unidadMedida: "Unidad",
    tasaImpuesto: 18.0,
    estado: true,
  ),
  Producto(
    idProducto: 5,
    idCategoria: 5,
    categoria: "Postres",
    nombreProducto: "Galletas de Chocolate Pack de 6",
    descripcion: "Paquete con seis galletas de chocolate",
    codigoProducto: "POS-001",
    precioCompra: 27.00,
    precioVenta: 35.00,
    stockActual: 15,
    unidadMedida: "Paquete",
    tasaImpuesto: 15.0,
    estado: true,
  ),
  Producto(
    idProducto: 6,
    idCategoria: 1,
    categoria: "Lácteos",
    nombreProducto: "Queso Crema",
    descripcion: "Queso crema en presentación de 200 gramos",
    codigoProducto: "LAC-002",
    precioCompra: 42.00,
    precioVenta: 55.00,
    stockActual: 18,
    unidadMedida: "Unidad",
    tasaImpuesto: 15.0,
    estado: true,
  ),
  Producto(
    idProducto: 7,
    idCategoria: 2,
    categoria: "Cereales",
    nombreProducto: "Avena Integral",
    descripcion: "Avena integral en presentación de 500 gramos",
    codigoProducto: "CER-002",
    precioCompra: 32.00,
    precioVenta: 42.00,
    stockActual: 22,
    unidadMedida: "Paquete",
    tasaImpuesto: 0.0,
    estado: true,
  ),
  Producto(
    idProducto: 8,
    idCategoria: 3,
    categoria: "Proteínas",
    nombreProducto: "Atún en Lata",
    descripcion: "Atún en agua en presentación de 140 gramos",
    codigoProducto: "PRO-002",
    precioCompra: 25.00,
    precioVenta: 34.00,
    stockActual: 8,
    unidadMedida: "Unidad",
    tasaImpuesto: 15.0,
    estado: true,
  ),
  Producto(
    idProducto: 9,
    idCategoria: 4,
    categoria: "Bebidas",
    nombreProducto: "Jugo de Naranja 1L",
    descripcion: "Jugo de naranja en presentación de un litro",
    codigoProducto: "BEB-002",
    precioCompra: 38.00,
    precioVenta: 49.00,
    stockActual: 16,
    unidadMedida: "Unidad",
    tasaImpuesto: 15.0,
    estado: true,
  ),
  Producto(
    idProducto: 10,
    idCategoria: 5,
    categoria: "Postres",
    nombreProducto: "Pastel de Vainilla",
    descripcion: "Pastel de vainilla para ocho porciones",
    codigoProducto: "POS-002",
    precioCompra: 120.00,
    precioVenta: 160.00,
    stockActual: 4,
    unidadMedida: "Unidad",
    tasaImpuesto: 15.0,
    estado: true,
  ),
];

class ListadoProductosScreen extends StatefulWidget {
  const ListadoProductosScreen({super.key});

  @override
  State<ListadoProductosScreen> createState() => _ListadoProductosScreenState();
}

class _ListadoProductosScreenState extends State<ListadoProductosScreen> {
  String _busqueda = "";

  List<Producto> get _productosFiltrados {
    final texto = _busqueda.toLowerCase().trim();
    if (texto.isEmpty) return _productos;

    return _productos.where((producto) {
      return producto.nombreProducto.toLowerCase().contains(texto) ||
          producto.categoria.toLowerCase().contains(texto) ||
          producto.codigoProducto.toLowerCase().contains(texto);
    }).toList();
  }

  Future<void> _abrirFormulario([Producto? producto]) async {
    final guardado = await Navigator.pushNamed(
      context,
      '/formulario_producto',
      arguments: producto,
    );

    if (!mounted || guardado != true) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            producto == null
                ? "Producto creado correctamente"
                : "Producto actualizado correctamente",
          ),
          backgroundColor: AppColors.success,
        ),
      );
  }

  IconData _obtenerIcono(String categoria) {
    switch (categoria) {
      case "Lácteos":
        return Icons.local_drink_outlined;
      case "Cereales":
        return Icons.rice_bowl_outlined;
      case "Proteínas":
        return Icons.egg_outlined;
      case "Bebidas":
        return Icons.wine_bar_outlined;
      case "Postres":
        return Icons.cookie_outlined;
      default:
        return Icons.inventory_2_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final productos = _productosFiltrados;
    final anchoPantalla = MediaQuery.of(context).size.width;
    final paddingHorizontal = anchoPantalla > 600 ? 80.0 : 10.0;

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
            padding: EdgeInsets.symmetric(
              horizontal: paddingHorizontal,
              vertical: 10,
            ),
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
          Expanded(
            child: productos.isEmpty
                ? const Center(child: Text("No se encontraron productos"))
                : ListView.builder(
                    padding: EdgeInsets.only(
                      left: paddingHorizontal,
                      right: paddingHorizontal,
                      bottom: 90,
                    ),
                    itemCount: productos.length,
                    itemBuilder: (context, index) {
                      final producto = productos[index];

                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        color: AppColors.white,
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(14),
                          onTap: () => _abrirFormulario(producto),
                          leading: Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: AppColors.background,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              _obtenerIcono(producto.categoria),
                              color: AppColors.primary,
                            ),
                          ),
                          title: Text(
                            producto.nombreProducto,
                            style: AppTextStyles.cardTitle,
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 3),
                              Text(
                                producto.categoria,
                                style: AppTextStyles.subtitle,
                              ),
                              const SizedBox(height: 5),
                              Text(
                                "Stock: ${producto.stockActual}",
                                style: AppTextStyles.subtitle.copyWith(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: producto.stockActual > 10
                                      ? AppColors.success
                                      : AppColors.warning,
                                ),
                              ),
                            ],
                          ),
                          trailing: Column(
                            mainAxisSize: MainAxisSize.min,
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
