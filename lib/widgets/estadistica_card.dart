import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../config/app_text_styles.dart';
import '../screens/listado_productos_screen.dart';

class EstadisticaCard extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String title;
  final String value;
  

  const EstadisticaCard({super.key, required this.color, required this.icon, required this.title, this.value = "150"});

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

        child: Row(
          children: [
            const SizedBox(width: 12),

            Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                size: 30,
                color: color,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.cardTitle),
                  Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: color)),
                ],
              ),
            ),
            const SizedBox(width: 10),

          ],
        ),
      ),
    );
  }
}
