import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../config/app_text_styles.dart';

class DetalleProductoScreen extends StatelessWidget {
  const DetalleProductoScreen({
    super.key,
    required this.icon,
    required this.title,
    required this.category,
    required this.price,
    required this.stock,
  });

  final IconData icon;
  final String title;
  final String category;
  final String price;
  final int stock;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text("Detalle del producto", style: AppTextStyles.screenTitle),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Card(
              elevation: 4,
              color: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                padding: const EdgeInsets.all(24),
                width: 280,
                child: Column(
                  children: [
                    const SizedBox(height: 15),
                    Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Icon(icon, size: 70, color: AppColors.secondary),
                    ),

                    const SizedBox(height: 25),

                    Text(
                      title,
                      style: AppTextStyles.cardTitle.copyWith(fontSize: 22),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 8),

                    Text(category, style: AppTextStyles.subtitle),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            Card(
              elevation: 2,
              color: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  children: [
                    _InfoRow(
                      icon: Icons.barcode_reader,
                      title: "Código",
                      value: "# 37283746",
                      color: AppColors.black,
                    ),
                    const Divider(),
                    _InfoRow(
                      icon: Icons.attach_money,
                      title: "Precio",
                      value: price,
                    ),

                    const Divider(),

                    _InfoRow(
                      icon: Icons.inventory_2,
                      title: "Stock disponible",
                      value: stock.toString(),
                      color: stock > 10 ? AppColors.success : AppColors.warning,
                    ),
                    const Divider(),
                    _InfoRow(
                      icon: Icons.category_outlined,
                      title: "Categoría",
                      value: category,
                      color: AppColors.warning,
                    ),
                  ],
                ),
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.edit),
                label: const Text("Editar producto"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.delete),
                label: const Text("Eliminar producto"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error,
                  foregroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
            SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.title,
    required this.value,
    this.color,
  });

  final IconData icon;
  final String title;
  final String value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color ?? AppColors.primary, size: 22),

        const SizedBox(width: 15),

        Expanded(child: Text(title, style: AppTextStyles.subtitle)),

        Text(
          value,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: color ?? AppColors.primary,
          ),
        ),
      ],
    );
  }
}
