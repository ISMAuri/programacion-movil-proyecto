import 'package:flutter/material.dart';
import '../config/app_text_styles.dart';
import '../config/app_colors.dart';
import '../widgets/venta_card.dart';
import 'formulario_venta_screen.dart';

class VentasScreen extends StatelessWidget {
  const VentasScreen({super.key});

  Widget _ventaCard(
    BuildContext context, {
    required int idVenta,
    required String numeroFactura,
    required String cliente,
    required String fechaVenta,
    required double total,
    required String estadoPago,
    required String metodoPago,
    required int idProducto,
    required int cantidad,
  }) {
    final partesFecha = fechaVenta.split("/");
    final fechaInicial = DateTime(
      int.parse(partesFecha[2]),
      int.parse(partesFecha[1]),
      int.parse(partesFecha[0]),
    );

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FormularioVentaScreen(
              idVenta: idVenta,
              clienteNombreInicial: cliente,
              numeroFactura: numeroFactura,
              metodoPagoInicial: metodoPago,
              estadoPagoInicial: estadoPago,
              fechaVentaInicial: fechaInicial,
              productoIdInicial: idProducto,
              cantidadInicial: cantidad,
            ),
          ),
        );
      },
      child: VentaCard(
        numeroFactura: numeroFactura,
        cliente: cliente,
        fechaVenta: fechaVenta,
        total: total,
        estadoPago: estadoPago,
        metodoPago: metodoPago,
      ),
    );
  }

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
        children: [
          _ventaCard(
            context,
            idVenta: 1,
            numeroFactura: "000-001-01-00001234",
            cliente: "Supermercado La Colonia",
            fechaVenta: "05/08/2026",
            total: 350.75,
            estadoPago: "Pagado",
            metodoPago: "Efectivo",
            idProducto: 1,
            cantidad: 1,
          ),
          _ventaCard(
            context,
            idVenta: 2,
            numeroFactura: "000-001-01-00001235",
            cliente: "Distribuidora El Sol S.A.",
            fechaVenta: "06/08/2026",
            total: 2450.00,
            estadoPago: "Pendiente",
            metodoPago: "Transferencia",
            idProducto: 3,
            cantidad: 1,
          ),
          _ventaCard(
            context,
            idVenta: 3,
            numeroFactura: "000-001-01-00001236",
            cliente: "Tienda de Ropa Fashion",
            fechaVenta: "07/08/2026",
            total: 120.50,
            estadoPago: "Pagado",
            metodoPago: "Tarjeta",
            idProducto: 4,
            cantidad: 2,
          ),
          _ventaCard(
            context,
            idVenta: 4,
            numeroFactura: "000-001-01-00001237",
            cliente: "Mini Market La Esquina",
            fechaVenta: "08/08/2026",
            total: 890.00,
            estadoPago: "Anulado",
            metodoPago: "Efectivo",
            idProducto: 2,
            cantidad: 2,
          ),
          _ventaCard(
            context,
            idVenta: 5,
            numeroFactura: "000-001-01-00001238",
            cliente: "Panadería y Pastelería Dulce Hogar",
            fechaVenta: "09/08/2026",
            total: 60.00,
            estadoPago: "Pagado",
            metodoPago: "Transferencia",
            idProducto: 5,
            cantidad: 2,
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
