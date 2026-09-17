import 'package:flutter/material.dart';

//Widget que muestra un badge con el estado de un elemento (activo o inactivo)
class EstadoBadge extends StatelessWidget {
  final bool estado;
  final String textoActivo;
  final String textoInactivo;

  const EstadoBadge({ //Parametro opcional con valores por defecto
    super.key,
    required this.estado, //es required porque sin saber si esta activo o inactivo el widget no se dibuja 
    this.textoActivo = 'Activo',
    this.textoInactivo = 'Inactivo', //opcionales porque evita que vez que uso EstadoBadge en otra pantalla tenga que escribir ese texto de nuevo, 
    //pero si en algún caso necesito otra palabra, lo puedo sobrescribir.
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
