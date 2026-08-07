import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../widgets/vista_producto_card.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Barra superior
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 46,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const TextField(
                    decoration: InputDecoration(
                      hintText: "Buscar productos...",
                      prefixIcon: Icon(Icons.search),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                height: 46,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Row(
                  children: [
                    Text("Categoría"),
                    Icon(Icons.keyboard_arrow_down),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Container(
                height: 46,
                width: 46,
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.tune, color: Colors.white),
              ),
            ],
          ),
        ),

        // Resultados
        Expanded(
          child: ListView(
            children: [
              VistaProductoCard(
                icon: Icons.local_drink_outlined,
                title: "Leche Entera 1L",
                category: "Lácteos",
                price: "L. 60.59",
                stock: "26",
              ),
              // arroz
              VistaProductoCard(
                icon: Icons.rice_bowl_outlined,
                title: "Arroz 2 lbs",
                category: "Cereales",
                price: "L. 30.00",
                stock: "52",
              ),
              VistaProductoCard(
                icon: Icons.egg_outlined,
                title: "Huevos Docena",
                category: "Proteínas",
                price: "L. 45.00",
                stock: "5",
              ),
              VistaProductoCard(
                icon: Icons.wine_bar_outlined,
                title: "Vino Tinto 750ml",
                category: "Bebidas",
                price: "L. 120.00",
                stock: "9",
              ),
              VistaProductoCard(
                icon: Icons.cookie_outlined,
                title: "Galletas de Chocolate Pack de 6",
                category: "Postres",
                price: "L. 35.00",
                stock: "15",
              ),
            ],
          ),
        ),
      ],
    );
  }
}
