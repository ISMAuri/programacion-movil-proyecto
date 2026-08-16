import 'package:flutter/material.dart';

class EstadoBadge extends StatelessWidget {
  final bool estado;
  final String textoActivo;
  final String textoInactivo;

  const EstadoBadge({
    super.key,
    required this.estado,
    this.textoActivo = 'Activo',
    this.textoInactivo = 'Inactivo',
  });

  @override
  Widget build(BuildContext context) {
    final Color color = estado ? Colors.green : Colors.red;

    final IconData icono = estado ? Icons.check_circle : Icons.cancel;

    final String texto = estado ? textoActivo : textoInactivo;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.65), width: 1),
      ),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 5,
        children: [
          Icon(icono, color: color, size: 16),
          Text(
            texto,
            style: TextStyle(color: color, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
