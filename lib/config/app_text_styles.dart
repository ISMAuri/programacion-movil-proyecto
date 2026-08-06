import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  // titulo del appbar
  static const TextStyle screenTitle = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
    static const TextStyle screenTitle2 = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: Colors.black87,
  );

  // titulos por seccion
  static const TextStyle sectionTitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.black87,
  );

  // titulo de cards
  static const TextStyle cardTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.black87,
  );

  // textos secundarios
  static const TextStyle subtitle = TextStyle(
    fontSize: 14,
    color: Colors.black54,
  );

    static const TextStyle subtitle2 = TextStyle(
    fontSize: 14,
    color: Colors.white70,
  );

  // estadisticas
  static const TextStyle statistic = TextStyle(
    fontSize: 34,
    fontWeight: FontWeight.bold,
  );

  // precios
  static const TextStyle price = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: AppColors.success,
  );

  // botoenes
  static const TextStyle button = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
  );
}