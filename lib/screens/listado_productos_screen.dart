import 'package:flutter/material.dart';
import '../config/app_text_styles.dart';
import '../config/app_colors.dart';
import '../widgets/search_bar_widget.dart';

class ListadoProductosScreen extends StatelessWidget {
  const ListadoProductosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Productos", style: AppTextStyles.screenTitle),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(
          color: AppColors.white, // color del icono del drawer
        ),
      ),
      body: SearchBarWidget(), // Aquí se utiliza el widget de la barra de búsqueda
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Acción al presionar el botón
        },
        backgroundColor: AppColors.secondary,
        foregroundColor: AppColors.white,
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
