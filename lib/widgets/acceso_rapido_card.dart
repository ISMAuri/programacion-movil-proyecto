import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../config/app_text_styles.dart';
import '../screens/listado_productos_screen.dart';

class AccesoRapidoCard extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String title;

  const AccesoRapidoCard({
    super.key,
    required this.color,
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const Center(child: ListadoProductosScreen()),
          ),
        );
      },
      child: Card(
        color: AppColors.white,

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 12),

            Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 30, color: color),
            ),

            const SizedBox(height: 12),

            Text(title, style: AppTextStyles.cardTitle),
            SizedBox(height: 6),
          ],
        ),
      ),
    );
  }
}
