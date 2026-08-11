import 'package:flutter/material.dart';
import '../config/app_text_styles.dart';
import '../config/app_colors.dart';
import '../models/categoria_model.dart';
import '../widgets/categoria_card.dart';

class CategoriasScreen extends StatelessWidget {
  const CategoriasScreen({super.key});

  void _abrirFormularioEdicion(BuildContext context, Categoria categoria) {
    Navigator.pushNamed(context, '/formulario_categoria', arguments: categoria);
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
              Categoria(
                idCategoria: 1,
                nombreCategoria: "Lácteos",
                descripcion: "Leche, quesos, yogurt y derivados",
                estado: true,
              ),
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
              Categoria(
                idCategoria: 2,
                nombreCategoria: "Cereales",
                descripcion: "Arroz, avena, granos y harinas",
                estado: true,
              ),
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
              Categoria(
                idCategoria: 3,
                nombreCategoria: "Proteínas",
                descripcion: "Huevos, carnes y embutidos",
                estado: true,
              ),
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
              Categoria(
                idCategoria: 4,
                nombreCategoria: "Bebidas",
                descripcion: "Jugos, gaseosas y bebidas alcohólicas",
                estado: false,
              ),
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
              Categoria(
                idCategoria: 5,
                nombreCategoria: "Postres",
                descripcion: "Galletas, dulces y repostería",
                estado: true,
              ),
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
          Navigator.pushNamed(context, '/formulario_categoria');
        },
        backgroundColor: AppColors.secondary,
        foregroundColor: AppColors.white,
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
