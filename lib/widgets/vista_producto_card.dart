import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../config/app_text_styles.dart';
import '../screens/detalle_producto_screen.dart';

class VistaProductoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String category;
  final String price;
  final int stock;

  const VistaProductoCard({
    super.key,
    required this.icon,
    required this.title,
    required this.category,
    required this.price,
    required this.stock,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetalleProductoScreen(
              icon: icon,
              title: title,
              category: category,
              price: price,
              stock: stock,
            ),
          ),
        );
      },
      child: _InfoCard(icon: icon, title: title, category: category, price: price, stock: stock),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.icon,
    required this.title,
    required this.category,
    required this.price,
    required this.stock,
  });

  final IconData icon;
  final String title;
  final String category;
  final String price;
  final int stock;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        child: Row(
          spacing: 20,
          children: [
            Icon(icon, color: AppColors.secondary, size: 40),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.cardTitle),
                  Text(category, style: AppTextStyles.subtitle),
                  Text(price, style: AppTextStyles.price),
                ],
              ),
            ),
            
            Container(
              width: 45,
              height: 45,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: stock > 10
                    ? AppColors.success.withOpacity(0.1)
                    : AppColors.warning.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                stock.toString(),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: stock > 10
                      ? AppColors.success
                      : AppColors.warning,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
