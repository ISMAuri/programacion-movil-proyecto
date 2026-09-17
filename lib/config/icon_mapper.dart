import 'package:flutter/material.dart';

// Mapea el nombre del icono que envia el backend (campo 'icono' de Categoria)
// a un IconData de Material Icons. Si no se reconoce el nombre del
// se usa un icono generico de servicios de respaldo

const Map<String, IconData> iconosPorNombre = {
  'pumbling': Icons.plumbing,
  'electrical_services': Icons.electrical_services,
  'carpenter': Icons.carpenter,
  'format_paint': Icons.format_paint,
  'cleaning_services': Icons.cleaning_services,
  'yard': Icons.yard,
  'ac_unit': Icons.ac_unit,
  'handyman': Icons.handyman,
  'pest_control': Icons.pest_control,
  'build': Icons.build,
  'roofing': Icons.roofing,
  'pumbling_outlined': Icons.plumbing_outlined,
};

IconData mapearIcono(String nombreIcono) {
  return iconosPorNombre[nombreIcono] ?? Icons.miscellaneous_services;
}
