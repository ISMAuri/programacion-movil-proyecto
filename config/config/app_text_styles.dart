import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  // AppBar title
  static const TextStyle screenTitle = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  // Section titles
  static const TextStyle sectionTitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.black87,
  );

  // Card titles
  static const TextStyle cardTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.black87,
  );

  // Secondary text
  static const TextStyle subtitle = TextStyle(
    fontSize: 14,
    color: Colors.black54,
  );

  // Statistics
  static const TextStyle statistic = TextStyle(
    fontSize: 34,
    fontWeight: FontWeight.bold,
  );

  // Prices
  static const TextStyle price = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: AppColors.success,
  );

  // Buttons
  static const TextStyle button = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
  );
}