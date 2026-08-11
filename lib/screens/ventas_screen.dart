import 'package:flutter/material.dart';
import '../config/app_text_styles.dart';
import '../config/app_colors.dart';
import '../widgets/venta_card.dart';
import 'formulario_ventas_screen.dart';

class VentasScreen extends StatelessWidget {
  const VentasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ventas", style: AppTextStyles.screenTitle),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
      ),
      backgroundColor: AppColors.background,
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 10),
        children: const [
          VentaCard(
            numeroFactura: "000-001-01-00001234",
            cliente: "Supermercado La Colonia",
            fechaVenta: "05/08/2026",
            total: 350.75,
            estadoPago: "Pagado",
            metodoPago: "Efectivo",
          ),
          VentaCard(
            numeroFactura: "000-001-01-00001235",
            cliente: "Distribuidora El Sol S.A.",
            fechaVenta: "06/08/2026",
            total: 2450.00,
            estadoPago: "Pendiente",
            metodoPago: "Transferencia",
          ),
          VentaCard(
            numeroFactura: "000-001-01-00001236",
            cliente: "Tienda de Ropa Fashion",
            fechaVenta: "07/08/2026",
            total: 120.50,
            estadoPago: "Pagado",
            metodoPago: "Tarjeta",
          ),
          VentaCard(
            numeroFactura: "000-001-01-00001237",
            cliente: "Mini Market La Esquina",
            fechaVenta: "08/08/2026",
            total: 890.00,
            estadoPago: "Anulado",
            metodoPago: "Efectivo",
          ),
          VentaCard(
            numeroFactura: "000-001-01-00001238",
            cliente: "Panadería y Pastelería Dulce Hogar",
            fechaVenta: "09/08/2026",
            total: 60.00,
            estadoPago: "Pagado",
            metodoPago: "Transferencia",
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const FormularioVentaScreen(),
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
