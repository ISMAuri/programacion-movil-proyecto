import 'package:flutter/material.dart';

import '../config/app_colors.dart';
import '../config/app_text_styles.dart';

class AccesoRapidoCard extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String title;
  final String routeName;

  const AccesoRapidoCard({
    super.key,
    required this.color,
    required this.icon,
    required this.title,
    required this.routeName,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, routeName);
      },
      child: Card(
        elevation: 4,
        color: AppColors.white,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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

                Text(
                  title,
                  style: AppTextStyles.cardTitle,
                  textAlign: TextAlign.center,
                ),
              ],
            ),

            const Positioned(
              right: 12,
              child: Icon(Icons.chevron_right, color: AppColors.disabled),
            ),
          ],
        ),
      ),
    );
  }
}
