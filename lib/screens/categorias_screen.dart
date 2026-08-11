import 'package:flutter/material.dart';
import '../config/app_text_styles.dart';
import '../config/app_colors.dart';
import '../widgets/categoria_card.dart';
import 'formulario_categoria_screen.dart';

class CategoriasScreen extends StatelessWidget {
  const CategoriasScreen({super.key});

  void _abrirFormularioEdicion(
    BuildContext context, {
    required String nombre,
    required String descripcion,
    required bool activo,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FormularioCategoriaScreen(
          nombreCategoria: nombre,
          descripcion: descripcion,
          activo: activo,
        ),
      ),
    );
  }

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
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => _abrirFormularioEdicion(
              context,
              nombre: "Lácteos",
              descripcion: "Leche, quesos, yogurt y derivados",
              activo: true,
            ),
            child: const CategoriaCard(
              nombre: "Lácteos",
              descripcion: "Leche, quesos, yogurt y derivados",
              activo: true,
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => _abrirFormularioEdicion(
              context,
              nombre: "Cereales",
              descripcion: "Arroz, avena, granos y harinas",
              activo: true,
            ),
            child: const CategoriaCard(
              nombre: "Cereales",
              descripcion: "Arroz, avena, granos y harinas",
              activo: true,
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => _abrirFormularioEdicion(
              context,
              nombre: "Proteínas",
              descripcion: "Huevos, carnes y embutidos",
              activo: true,
            ),
            child: const CategoriaCard(
              nombre: "Proteínas",
              descripcion: "Huevos, carnes y embutidos",
              activo: true,
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => _abrirFormularioEdicion(
              context,
              nombre: "Bebidas",
              descripcion: "Jugos, gaseosas y bebidas alcohólicas",
              activo: false,
            ),
            child: const CategoriaCard(
              nombre: "Bebidas",
              descripcion: "Jugos, gaseosas y bebidas alcohólicas",
              activo: false,
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => _abrirFormularioEdicion(
              context,
              nombre: "Postres",
              descripcion: "Galletas, dulces y repostería",
              activo: true,
            ),
            child: const CategoriaCard(
              nombre: "Postres",
              descripcion: "Galletas, dulces y repostería",
              activo: true,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const FormularioCategoriaScreen(),
            ),
          );
        },
        backgroundColor: AppColors.secondary,
        foregroundColor: AppColors.white,
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
