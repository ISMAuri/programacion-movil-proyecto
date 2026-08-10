import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../config/app_text_styles.dart';

class MovimientoCard extends StatelessWidget {
  const MovimientoCard({
    super.key,
    required this.tipoMovimiento,
    required this.cantidad,
    required this.fechaMovimiento,
    required this.motivo,
    required this.producto,
    required this.encargado,
  });

  final String tipoMovimiento; // "Entrada" o "Salida"
  final int cantidad;
  final String fechaMovimiento;
  final String motivo;
  final String producto;
  final String encargado; // usuario que hizo el movimiento

  bool get _esEntrada => tipoMovimiento.toLowerCase() == "entrada";

  @override
  Widget build(BuildContext context) {
    final Color colorTipo = _esEntrada ? AppColors.success : AppColors.error;
    final IconData iconoTipo = _esEntrada
        ? Icons.arrow_downward
        : Icons.arrow_upward;

    return Card(
      elevation: 2,
      color: AppColors.white,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: colorTipo.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(iconoTipo, color: colorTipo, size: 22),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(tipoMovimiento, style: AppTextStyles.cardTitle),
                  const SizedBox(height: 2),
                  Text(producto, style: AppTextStyles.subtitle),
                  const SizedBox(height: 4),
                  Text(motivo, style: AppTextStyles.subtitle),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        Icons.person_outline,
                        size: 13,
                        color: AppColors.disabled,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        encargado,
                        style: AppTextStyles.subtitle.copyWith(fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    fechaMovimiento,
                    style: AppTextStyles.subtitle.copyWith(fontSize: 12),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 10),

            Text(
              _esEntrada ? "+$cantidad" : "-$cantidad",
              style: AppTextStyles.button.copyWith(color: colorTipo),
            ),
          ],
        ),
      ),
    );
  }
}
