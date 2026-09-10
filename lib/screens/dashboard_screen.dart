import 'package:flutter/material.dart';

import '../config/app_colors.dart';
import '../config/app_text_styles.dart';

import '../services/producto_service.dart';
import '../services/venta_service.dart';
import '../services/detalle_venta_service.dart';

import '../widgets/estadistica_card.dart';
import '../widgets/acceso_rapido_card.dart';
import '../widgets/opcion_menu_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final ProductoService _productoService = ProductoService();
  final VentaService _ventaService = VentaService();
  final DetalleVentaService _detalleVentaService = DetalleVentaService();

  bool cargando = true;

  int totalProductos = 0;
  int productosVendidos = 0;
  int productosBajoStock = 0;
  int productosAgotados = 0;

  Future<void> _cargarEstadisticas() async {
    try {
      final productos = await _productoService.getProductos(soloActivos: false);

      final ventas = await _ventaService.getVentas();

      // Solo tomamos en cuenta facturas emitidas.
      final ventasEmitidas = ventas
          .where((venta) => venta.estadoFactura)
          .toList();

      final detallesPorVenta = await Future.wait(
        ventasEmitidas.map(
          (venta) => _detalleVentaService.getDetallesPorVenta(venta.idVenta),
        ),
      );

      int cantidadVendida = 0;

      for (final detalles in detallesPorVenta) {
        for (final detalle in detalles) {
          cantidadVendida += detalle.cantidad;
        }
      }

      if (!mounted) return;

      setState(() {
        totalProductos = productos.length;

        productosVendidos = cantidadVendida;

        productosBajoStock = productos
            .where(
              (producto) =>
                  producto.stockActual > 0 && producto.stockActual <= 10,
            )
            .length;

        productosAgotados = productos
            .where((producto) => producto.stockActual == 0)
            .length;

        cargando = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        cargando = false;
      });

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text('Error al cargar estadísticas: $e'),
            backgroundColor: AppColors.error,
          ),
        );
    }
  }

  @override
  void initState() {
    super.initState();

    _cargarEstadisticas();
  }

  @override
  Widget build(BuildContext context) {
    final estadisticas = [
      {
        'color': AppColors.primary,
        'icon': Icons.inventory_2_outlined,
        'title': 'Total de Productos',
        'value': cargando ? '...' : totalProductos.toString(),
        'routeName': '/listado_productos',
      },
      {
        'color': AppColors.success,
        'icon': Icons.check_circle_outlined,
        'title': 'Productos Vendidos',
        'value': cargando ? '...' : productosVendidos.toString(),
        'routeName': '/ventas',
      },
      {
        'color': AppColors.warning,
        'icon': Icons.warning_amber_outlined,
        'title': 'Productos Bajos en Stock',
        'value': cargando ? '...' : productosBajoStock.toString(),
        'routeName': '/listado_productos',
      },
      {
        'color': AppColors.error,
        'icon': Icons.error_outline,
        'title': 'Productos Agotados',
        'value': cargando ? '...' : productosAgotados.toString(),
        'routeName': '/listado_productos',
      },
    ];

    final accesosRapidos = [
      {
        'color': AppColors.success,
        'icon': Icons.point_of_sale_outlined,
        'title': 'Ver Ventas',
        'routeName': '/ventas',
      },
      {
        'color': AppColors.warning,
        'icon': Icons.history_outlined,
        'title': 'Ver Movimientos',
        'routeName': '/movimientos',
      },
      {
        'color': AppColors.secondary,
        'icon': Icons.people_outline,
        'title': 'Ver Clientes',
        'routeName': '/clientes',
      },
      {
        'color': AppColors.error,
        'icon': Icons.category_outlined,
        'title': 'Ver Categorías',
        'routeName': '/categorias',
      },
    ];

    return RefreshIndicator(
      onRefresh: _cargarEstadisticas,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('¡Hola, Usuario!', style: AppTextStyles.sectionTitle),

              const SizedBox(height: 4),

              Text(
                'Aquí tienes un resumen de tu inventario.',
                style: AppTextStyles.subtitle,
              ),

              const SizedBox(height: 15),

              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: estadisticas.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.2,
                ),
                itemBuilder: (context, index) {
                  final estadistica = estadisticas[index];

                  return EstadisticaCard(
                    color: estadistica['color'] as Color,
                    icon: estadistica['icon'] as IconData,
                    title: estadistica['title'] as String,
                    value: estadistica['value'] as String,
                    routeName: estadistica['routeName'] as String,
                  );
                },
              ),

              const SizedBox(height: 20),

              Text('Accesos rápidos', style: AppTextStyles.sectionTitle),

              const SizedBox(height: 4),

              Text('Algunas funciones comunes.', style: AppTextStyles.subtitle),

              const SizedBox(height: 15),

              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: accesosRapidos.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.5,
                ),
                itemBuilder: (context, index) {
                  final acceso = accesosRapidos[index];

                  return AccesoRapidoCard(
                    color: acceso['color'] as Color,
                    icon: acceso['icon'] as IconData,
                    title: acceso['title'] as String,
                    routeName: acceso['routeName'] as String,
                  );
                },
              ),

              OpcionMenuCard(
                icon: Icons.add_shopping_cart_outlined,
                titulo: "Nueva venta",
                subtitulo: "Registrar una nueva venta",
                onTap: () => Navigator.pushNamed(context, "/formulario_venta"),
                onLongPress: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return const Dialog(
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Text(
                            'Esta opción permite registrar una nueva venta '
                            'en el sistema. Al seleccionar esta opción, se '
                            'abrirá un formulario donde se podrán ingresar '
                            'los detalles de la venta, incluyendo los '
                            'productos vendidos, cantidades, precios y datos '
                            'del cliente. Esta funcionalidad es esencial para '
                            'mantener un registro actualizado de las '
                            'transacciones comerciales y generar reportes '
                            'de ventas precisos.',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),

              OpcionMenuCard(
                icon: Icons.person_add_outlined,
                titulo: "Nuevo cliente",
                subtitulo: "Registrar un nuevo cliente",
                onTap: () =>
                    Navigator.pushNamed(context, "/formulario_cliente"),
                onLongPress: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return const Dialog(
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Text(
                            'Esta opción permite registrar un nuevo cliente '
                            'en el sistema. Al seleccionar esta opción, se '
                            'abrirá un formulario donde se podrán ingresar '
                            'los datos del nuevo cliente, incluyendo su '
                            'nombre, dirección, número de teléfono y correo '
                            'electrónico. Esta funcionalidad es esencial para '
                            'mantener un registro actualizado de los clientes '
                            'y facilitar la gestión de las relaciones con '
                            'ellos.',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),

              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}
