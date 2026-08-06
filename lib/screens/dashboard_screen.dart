import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../config/app_text_styles.dart';
import '../widgets/card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: AppColors.background,
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("¡Hola, Usuario!", style: AppTextStyles.sectionTitle),

            Text(
              "Aquí tienes un resumen de tu inventario.",
              style: AppTextStyles.subtitle,
            ),

            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              children: [
                CustomCard(),
                CustomCard(),
                CustomCard(),
                CustomCard(),
              ],
            ),

            SizedBox(height: 20),
            Text("Accesos rápidas", style: AppTextStyles.sectionTitle),

            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.5,
              crossAxisCount: 2,
              children: [
                CustomCard(),
                CustomCard(),
                CustomCard(),
                CustomCard(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
