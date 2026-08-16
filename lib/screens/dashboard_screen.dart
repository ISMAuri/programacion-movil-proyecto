import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../config/app_text_styles.dart';
import '../widgets/estadistica_card.dart';
import '../widgets/acceso_rapido_card.dart';
import '../widgets/opcion_menu_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final estadisticas = [
      {
        'color': AppColors.primary,
        'icon': Icons.inventory_2_outlined,
        'title': 'Total de Productos',
        'value': '150',
        'routeName': '/listado_productos',
      },
      {
        'color': AppColors.success,
        'icon': Icons.check_circle_outlined,
        'title': 'Productos Vendidos',
        'value': '120',
        'routeName': '/ventas',
      },
      {
        'color': AppColors.warning,
        'icon': Icons.warning_amber_outlined,
        'title': 'Productos Bajos en Stock',
        'value': '30',
        'routeName': '/listado_productos',
      },
      {
        'color': AppColors.error,
        'icon': Icons.error_outline,
        'title': 'Productos Agotados',
        'value': '5',
        'routeName': '/listado_productos',
      },
    ];

    final accesosRapidos = [
      // {
      //   'color': AppColors.primary,
      //   'icon': Icons.inventory_2_outlined,
      //   'title': 'Ver Productos',
      //   'routeName': '/listado_productos',
      // },
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

    return SingleChildScrollView(
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
                          'Esta opción permite registrar una nueva venta en el sistema. Al seleccionar esta opción, se abrirá un formulario donde se podrán ingresar los detalles de la venta, incluyendo los productos vendidos, cantidades, precios y datos del cliente. Esta funcionalidad es esencial para mantener un registro actualizado de las transacciones comerciales y generar reportes de ventas precisos.',
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
              onTap: () => Navigator.pushNamed(context, "/formulario_cliente"),
              onLongPress: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return const Dialog(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          'Esta opción permite registrar un nuevo cliente en el sistema. Al seleccionar esta opción, se abrirá un formulario donde se podrán ingresar los datos del nuevo cliente, incluyendo su nombre, dirección, número de teléfono y correo electrónico. Esta funcionalidad es esencial para mantener un registro actualizado de los clientes y facilitar la gestión de las relaciones con ellos.',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
