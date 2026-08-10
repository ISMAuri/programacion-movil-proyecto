import 'package:flutter/material.dart';
import '../config/app_text_styles.dart';
import '../config/app_colors.dart';
import '../widgets/categoria_card.dart';

class CategoriasScreen extends StatelessWidget {
  const CategoriasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Categorías", style: AppTextStyles.screenTitle),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
      ),
      backgroundColor: AppColors.background,
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 10),
        children: const [
          CategoriaCard(
            nombre: "Lácteos",
            descripcion: "Leche, quesos, yogurt y derivados",
            activo: true,
          ),
          CategoriaCard(
            nombre: "Cereales",
            descripcion: "Arroz, avena, granos y harinas",
            activo: true,
          ),
          CategoriaCard(
            nombre: "Proteínas",
            descripcion: "Huevos, carnes y embutidos",
            activo: true,
          ),
          CategoriaCard(
            nombre: "Bebidas",
            descripcion: "Jugos, gaseosas y bebidas alcohólicas",
            activo: false,
          ),
          CategoriaCard(
            nombre: "Postres",
            descripcion: "Galletas, dulces y repostería",
            activo: true,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          
        },
        backgroundColor: AppColors.secondary,
        foregroundColor: AppColors.white,
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
