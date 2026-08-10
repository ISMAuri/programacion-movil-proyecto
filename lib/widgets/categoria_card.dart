import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../config/app_text_styles.dart';

class CategoriaCard extends StatelessWidget {
  const CategoriaCard({
    super.key,
    required this.nombre,
    required this.descripcion,
    required this.activo,
  });

  final String nombre;
  final String descripcion;
  final bool activo;

  @override
  Widget build(BuildContext context) {
    final Color colorEstado = activo ? AppColors.success : AppColors.disabled;

    return Card(
      elevation: 2,
      color: AppColors.white,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: AppColors.secondary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.category_outlined,
                color: AppColors.secondary,
                size: 22,
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(nombre, style: AppTextStyles.cardTitle),
                  const SizedBox(height: 4),
                  Text(
                    descripcion,
                    style: AppTextStyles.subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            const SizedBox(width: 10),

            // Estado
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: colorEstado.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                activo ? "Activo" : "Inactivo",
                style: AppTextStyles.subtitle.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: colorEstado,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
