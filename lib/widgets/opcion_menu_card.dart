import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../config/app_text_styles.dart';

class OpcionMenuCard extends StatelessWidget {
  final IconData icon;
  final String titulo;
  final String? subtitulo;

  final VoidCallback onTap;
  final VoidCallback onLongPress;

  final Color colorIcono;
  final bool mostrarFlecha;

  const OpcionMenuCard({
    super.key,
    required this.icon,
    required this.titulo,
    this.subtitulo,
    required this.onTap,
    required this.onLongPress,
    this.colorIcono = AppColors.primary,
    this.mostrarFlecha = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        onTap: onTap,
        onLongPress: onLongPress,
        titleAlignment: ListTileTitleAlignment.center,

        leading: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: colorIcono.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: colorIcono, size: 20),
        ),

        title: Text(titulo, style: AppTextStyles.cardTitle),

        subtitle: subtitulo != null
            ? Text(subtitulo!, style: AppTextStyles.subtitle)
            : null,

        trailing: mostrarFlecha
            ? const Icon(Icons.chevron_right, color: AppColors.disabled)
            : null,
      ),
    );
  }
}
