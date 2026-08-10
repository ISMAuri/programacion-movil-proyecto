import 'package:flutter/material.dart';
import '../config/app_text_styles.dart';
import '../config/app_colors.dart';
import '../widgets/movimiento_card.dart';

class MovimientosScreen extends StatelessWidget {
  const MovimientosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Movimientos", style: AppTextStyles.screenTitle),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
      ),
      backgroundColor: AppColors.background,
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 10),
        children: const [
          MovimientoCard(
            tipoMovimiento: "Entrada",
            cantidad: 20,
            fechaMovimiento: "05/08/2026",
            motivo: "Compra a proveedor",
            producto: "Leche Entera 1L",
            encargado: "Carlos Martínez",
          ),
          // salida por venta
          MovimientoCard(
            tipoMovimiento: "Salida",
            cantidad: 5,
            fechaMovimiento: "06/08/2026",
            motivo: "Venta en mostrador",
            producto: "Arroz 2 lbs",
            encargado: "María Fernández",
          ),
          MovimientoCard(
            tipoMovimiento: "Salida",
            cantidad: 3,
            fechaMovimiento: "07/08/2026",
            motivo: "Producto dañado",
            producto: "Huevos Docena",
            encargado: "Carlos Martínez",
          ),
          MovimientoCard(
            tipoMovimiento: "Entrada",
            cantidad: 50,
            fechaMovimiento: "08/08/2026",
            motivo: "Reposición de stock",
            producto: "Vino Tinto 750ml",
            encargado: "José Reyes",
          ),
          MovimientoCard(
            tipoMovimiento: "Salida",
            cantidad: 2,
            fechaMovimiento: "09/08/2026",
            motivo: "Ajuste de inventario",
            producto: "Galletas de Chocolate Pack de 6",
            encargado: "María Fernández",
          ),
        ],
      ),
    );
  }
}
