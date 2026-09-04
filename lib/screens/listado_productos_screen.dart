import 'package:flutter/material.dart';

import '../config/app_colors.dart';
import '../config/app_text_styles.dart';
import '../models/categoria.dart';
import '../models/producto.dart';
import '../services/categoria_service.dart';
import '../services/producto_service.dart';
import '../widgets/estado_badge.dart';

class ListadoProductosScreen extends StatefulWidget {
  const ListadoProductosScreen({super.key});

  @override
  State<ListadoProductosScreen> createState() => _ListadoProductosScreenState();
}

class _ListadoProductosScreenState extends State<ListadoProductosScreen> {
  final ProductoService _productoService = ProductoService();
  final CategoriaService _categoriaService = CategoriaService();

  String _busqueda = '';
  bool cargando = true;

  List<Producto> _productos = [];
  List<Categoria> _categorias = [];

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    setState(() => cargando = true);

    try {
      final productos = await _productoService.getProductos(soloActivos: false);

      final categorias = await _categoriaService.getCategorias(
        soloActivas: false,
      );

      if (!mounted) return;

      setState(() {
        _productos = productos;
        _categorias = categorias;
        cargando = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() => cargando = false);

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text('Error al cargar productos'),
            backgroundColor: AppColors.error,
          ),
        );
    }
  }

  Categoria? _obtenerCategoria(int idCategoria) {
    for (final categoria in _categorias) {
      if (categoria.id == idCategoria) {
        return categoria;
      }
    }

    return null;
  }

  List<Producto> get _productosFiltrados {
    final texto = _busqueda.toLowerCase().trim();

    if (texto.isEmpty) {
      return _productos;
    }

    return _productos.where((producto) {
      final nombreCategoria =
          _obtenerCategoria(producto.idCategoria)?.nombre ?? '';

      return producto.nombreProducto.toLowerCase().contains(texto) ||
          nombreCategoria.toLowerCase().contains(texto) ||
          (producto.codigoProducto?.toLowerCase().contains(texto) ?? false);
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
                ? 'Producto creado correctamente.'
                : 'Producto actualizado correctamente.',
          ),
          backgroundColor: AppColors.success,
        ),
      );

    await _cargarDatos();
  }

  IconData _obtenerIcono(Categoria? categoria) {
    switch (categoria?.nombre.toLowerCase()) {
      case 'abarrotes':
        return Icons.shopping_basket_outlined;
      case 'bebidas':
        return Icons.local_drink_outlined;
      case 'limpieza':
        return Icons.cleaning_services_outlined;
      case 'higiene personal':
        return Icons.sanitizer_outlined;
      case 'papel y desechables':
        return Icons.inventory_2_outlined;
      case 'snacks y confitería':
        return Icons.cookie_outlined;
      case 'papelería':
        return Icons.edit_note_outlined;
      case 'ferretería y mantenimiento':
        return Icons.handyman_outlined;
      default:
        return Icons.inventory_2_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final productos = _productosFiltrados;
    final anchoPantalla = MediaQuery.of(context).size.width;
    final paddingHorizontal = anchoPantalla > 600 ? 80.0 : 10.0;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: paddingHorizontal,
            vertical: 10,
          ),
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
                    onChanged: (valor) {
                      setState(() => _busqueda = valor);
                    },
                    decoration: const InputDecoration(
                      hintText: 'Buscar por nombre, código o categoría...',
                      prefixIcon: Icon(Icons.search),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: _cargarDatos,
                icon: const Icon(Icons.refresh),
                tooltip: 'Actualizar productos',
                color: AppColors.primary,
              ),
            ],
          ),
        ),
        Expanded(
          child: cargando
              ? const Center(child: CircularProgressIndicator())
              : productos.isEmpty
              ? const Center(child: Text('No se encontraron productos'))
              : ListView.builder(
                  padding: EdgeInsets.only(
                    left: paddingHorizontal,
                    right: paddingHorizontal,
                    bottom: 90,
                  ),
                  itemCount: productos.length,
                  itemBuilder: (context, index) {
                    final producto = productos[index];
                    final categoria = _obtenerCategoria(producto.idCategoria);

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
                            _obtenerIcono(categoria),
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
                              categoria?.nombre ?? 'Sin categoría',
                              style: AppTextStyles.subtitle,
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Stock: ${producto.stockActual}',
                              style: AppTextStyles.subtitle.copyWith(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: producto.stockActual > 10
                                    ? AppColors.success
                                    : AppColors.warning,
                              ),
                            ),
                            const SizedBox(height: 4),
                            EstadoBadge(
                              estado: producto.estado,
                              textoActivo: 'Disponible',
                              textoInactivo: 'No disponible',
                            ),
                          ],
                        ),
                        trailing: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'L. ${producto.precioVenta.toStringAsFixed(2)}',
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
    );
  }
}
