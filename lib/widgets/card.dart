import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../config/app_text_styles.dart';
import '../screens/listado_productos_screen.dart';

class CustomCard extends StatelessWidget {
  // final Color color;
  // final Widget child;

  const CustomCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Center(child: ListadoProductosScreen())),
        );
      },
      child: Card(
        color: AppColors.white,
        child: Center(
          child: Text("Total de Productos", style: AppTextStyles.cardTitle),
        ),
      ),
    );
  }
}
