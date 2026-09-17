import 'package:flutter/material.dart';
import 'package:programacion_movil_proyecto/widgets/estado_badge.dart';
import '../config/app_colors.dart';
import '../config/app_text_styles.dart';

class ClienteCard extends StatelessWidget {
  const ClienteCard({
    super.key,
    required this.nombreCliente,
    required this.rtn,
    required this.direccion,
    required this.telefono,
    required this.correo,
    required this.fechaRegistro,
    required this.estado,
  });

  final String nombreCliente;
  final String rtn;
  final String direccion;
  final String telefono;
  final String correo;
  final String fechaRegistro;
  final bool estado;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
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
                    Icons.person_outline,
                    color: AppColors.secondary,
                    size: 22,
                  ),
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(nombreCliente, style: AppTextStyles.cardTitle),
                      const SizedBox(height: 2),
                      Text("RTN: $rtn", style: AppTextStyles.subtitle),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: AppColors.disabled,
                ),
              ],
            ),

            const Divider(height: 24),

            _ContactRow(icon: Icons.phone_outlined, value: telefono),
            const SizedBox(height: 8),
            _ContactRow(icon: Icons.email_outlined, value: correo),
            const SizedBox(height: 8),
            _ContactRow(icon: Icons.location_on_outlined, value: direccion),
            const SizedBox(height: 6),
            EstadoBadge(estado: estado),

            const SizedBox(height: 10),

            Align(
              alignment: Alignment.centerRight,
              child: Text(
                "Cliente desde $fechaRegistro",
                style: AppTextStyles.subtitle.copyWith(
                  fontSize: 11,
                  color: AppColors.disabled,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContactRow extends StatelessWidget {
  const _ContactRow({required this.icon, required this.value});

  final IconData icon;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.primary),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: AppTextStyles.subtitle,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
