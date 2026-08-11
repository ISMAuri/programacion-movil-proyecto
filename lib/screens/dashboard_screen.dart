import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../config/app_text_styles.dart';
import '../widgets/estadistica_card.dart';
import '../widgets/acceso_rapido_card.dart';
import 'clientes_screen.dart';
import 'listado_productos_screen.dart';
import 'movimientos_screen.dart';
import 'ventas_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("¡Hola, Usuario!", style: AppTextStyles.sectionTitle),
            SizedBox(height: 4),
            Text(
              "Aquí tienes un resumen de tu inventario.",
              style: AppTextStyles.subtitle,
            ),SizedBox(height: 15),

            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 1.2,
              children: [
                EstadisticaCard(
                  color: AppColors.primary,
                  icon: Icons.inventory_2_outlined,
                  title: "Total de Productos",
                  value: "150",
                ),
                EstadisticaCard(
                  color: AppColors.success,
                  icon: Icons.check_circle_outlined,
                  title: "Productos Vendidos",
                  value: "120",
                ),
                EstadisticaCard(
                  color: AppColors.warning,
                  icon: Icons.warning_amber_outlined,
                  title: "Productos Bajos en Stock",
                  value: "30",
                ),
                EstadisticaCard(
                  color: AppColors.error,
                  icon: Icons.error_outline,
                  title: "Productos Agotados",
                  value: "5",
                ),
              ],
            ),

            SizedBox(height: 20),
            Text("Accesos rápidos", style: AppTextStyles.sectionTitle),
            SizedBox(height: 4),
            Text(
              "Algunas funciones comunes.",
              style: AppTextStyles.subtitle,
            ),
            SizedBox(height: 15),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.5,
              crossAxisCount: 2,
              children: [
                AccesoRapidoCard(
                  color: AppColors.primary,
                  icon: Icons.inventory_2_outlined,
                  title: "Ver Productos",
                  screen: ListadoProductosScreen(), 
                ),
                AccesoRapidoCard(
                  color: AppColors.primary,
                  icon: Icons.point_of_sale_outlined,
                  title: "Ver Ventas",
                  screen: VentasScreen(), 
                ),
                AccesoRapidoCard(
                  color: AppColors.warning,
                  icon: Icons.history_outlined,
                  title: "Ver Movimientos",
                  screen: MovimientosScreen(), 
                ),
                AccesoRapidoCard(
                  color: AppColors.secondary,
                  icon: Icons.people_outline,
                  title: "Ver Clientes",
                  screen: ClientesScreen(), 
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
