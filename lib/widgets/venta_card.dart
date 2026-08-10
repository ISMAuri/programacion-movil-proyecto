import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../config/app_text_styles.dart';

class VentaCard extends StatelessWidget {
  const VentaCard({
    super.key,
    required this.numeroFactura,
    required this.cliente,
    required this.fechaVenta,
    required this.total,
    required this.estadoPago,
    required this.metodoPago,
  });

  final String numeroFactura;
  final String cliente;
  final String fechaVenta;
  final double total;
  final String estadoPago;
  final String metodoPago;

  Color get _colorEstado {
    switch (estadoPago.toLowerCase()) {
      case "pagado":
        return AppColors.success;
      case "pendiente":
        return AppColors.warning;
      case "anulado":
        return AppColors.error;
      default:
        return AppColors.disabled;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: AppColors.white,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.receipt_long_outlined,
                    color: AppColors.secondary,
                    size: 22,
                  ),
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Factura $numeroFactura",
                        style: AppTextStyles.cardTitle,
                      ),
                      const SizedBox(height: 2),
                      Text(cliente, style: AppTextStyles.subtitle),
                    ],
                  ),
                ),

                // Estado de pago
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: _colorEstado.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    estadoPago,
                    style: AppTextStyles.subtitle.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: _colorEstado,
                    ),
                  ),
                ),
              ],
            ),

            const Divider(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                      size: 14,
                      color: AppColors.disabled,
                    ),
                    const SizedBox(width: 6),
                    Text(fechaVenta, style: AppTextStyles.subtitle),
                    const SizedBox(width: 14),
                    const Icon(
                      Icons.payments_outlined,
                      size: 14,
                      color: AppColors.disabled,
                    ),
                    const SizedBox(width: 6),
                    Text(metodoPago, style: AppTextStyles.subtitle),
                  ],
                ),
                Text(
                  "L. ${total.toStringAsFixed(2)}",
                  style: AppTextStyles.price.copyWith(fontSize: 16),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
