import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../config/app_text_styles.dart';

class VistaProductoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String category;
  final String price;
  final String stock;

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
    return Card(
      color: AppColors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        child: Row(
          spacing: 20,
          children: [
            Icon(icon, color: AppColors.secondary, size: 40),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.cardTitle),
                Text(category, style: AppTextStyles.subtitle),
                Text(price, style: AppTextStyles.price),
              ],
            ),
            Spacer(),
            Container(
              width: 45,
              height: 45,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: int.parse(stock) > 10
                    ? AppColors.success.withOpacity(0.1)
                    : AppColors.warning.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                stock,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: int.parse(stock) > 10
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
