import 'package:flutter/material.dart';
import '../config/app_text_styles.dart';
import '../config/app_colors.dart';
import '../widgets/venta_card.dart';
import '../models/venta_model.dart';
import '../models/detalle_venta_model.dart';

class VentasScreen extends StatelessWidget {
  const VentasScreen({super.key});

  Future<void> _abrirFormulario(
    BuildContext context, [
    Venta? venta,
  ]) async {
    final guardado = await Navigator.pushNamed(
      context,
      '/formulario_venta',
      arguments: venta,
    );

    if (!context.mounted || guardado != true) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            venta == null
                ? 'Venta registrada correctamente'
                : 'Venta actualizada correctamente',
          ),
          backgroundColor: AppColors.success,
        ),
      );
  }

  Widget _ventaCard(BuildContext context, Venta venta) {
    final fecha =
        '${venta.fechaVenta.day.toString().padLeft(2, '0')}/'
        '${venta.fechaVenta.month.toString().padLeft(2, '0')}/'
        '${venta.fechaVenta.year}';

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _abrirFormulario(context, venta),
      child: VentaCard(
        numeroFactura: venta.numeroFactura,
        cliente: venta.nombreCliente,
        fechaVenta: fecha,
        total: venta.total,
        estadoPago: venta.estadoPago,
        metodoPago: venta.metodoPago,
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
          _ventaCard(context, Venta(
            idVenta: 1,
            idCliente: 5,
            numeroFactura: "000-001-01-00001234",
            nombreCliente: "Supermercado La Colonia",
            fechaVenta: DateTime(2026, 8, 5),
            subtotal: 305.00,
            impuesto: 45.75,
            total: 350.75,
            estadoPago: "Pagado",
            metodoPago: "Efectivo",
            estado: true,
            detalles: const [DetalleVenta(idDetalleVenta: 1, idProducto: 1, nombreProducto: "Camisa polo", cantidad: 1, precioUnitario: 305.00, tasaImpuesto: 15, subtotal: 305.00)],
          )),
          _ventaCard(context, Venta(
            idVenta: 2,
            idCliente: 6,
            numeroFactura: "000-001-01-00001235",
            nombreCliente: "Distribuidora El Sol S.A.",
            fechaVenta: DateTime(2026, 8, 6),
            subtotal: 2076.27,
            impuesto: 373.73,
            total: 2450.00,
            estadoPago: "Pendiente",
            metodoPago: "Transferencia",
            estado: true,
            detalles: const [DetalleVenta(idDetalleVenta: 2, idProducto: 3, nombreProducto: "Laptop 14 pulgadas", cantidad: 1, precioUnitario: 2076.27, tasaImpuesto: 18, subtotal: 2076.27)],
          )),
          _ventaCard(context, Venta(
            idVenta: 3,
            idCliente: 7,
            numeroFactura: "000-001-01-00001236",
            nombreCliente: "Tienda de Ropa Fashion",
            fechaVenta: DateTime(2026, 8, 7),
            subtotal: 104.78,
            impuesto: 15.72,
            total: 120.50,
            estadoPago: "Pagado",
            metodoPago: "Tarjeta",
            estado: true,
            detalles: const [DetalleVenta(idDetalleVenta: 3, idProducto: 4, nombreProducto: "Cuaderno universitario", cantidad: 2, precioUnitario: 52.39, tasaImpuesto: 15, subtotal: 104.78)],
          )),
          _ventaCard(context, Venta(
            idVenta: 4,
            idCliente: 8,
            numeroFactura: "000-001-01-00001237",
            nombreCliente: "Mini Market La Esquina",
            fechaVenta: DateTime(2026, 8, 8),
            subtotal: 890.00,
            impuesto: 0,
            total: 890.00,
            estadoPago: "Anulado",
            metodoPago: "Efectivo",
            estado: false,
            detalles: const [DetalleVenta(idDetalleVenta: 4, idProducto: 2, nombreProducto: "Pan francés (docena)", cantidad: 2, precioUnitario: 445.00, tasaImpuesto: 0, subtotal: 890.00)],
          )),
          _ventaCard(context, Venta(
            idVenta: 5,
            idCliente: 9,
            numeroFactura: "000-001-01-00001238",
            nombreCliente: "Panadería y Pastelería Dulce Hogar",
            fechaVenta: DateTime(2026, 8, 9),
            subtotal: 60.00,
            impuesto: 0,
            total: 60.00,
            estadoPago: "Pagado",
            metodoPago: "Transferencia",
            estado: true,
            detalles: const [DetalleVenta(idDetalleVenta: 5, idProducto: 5, nombreProducto: "Leche entera 1L", cantidad: 2, precioUnitario: 30.00, tasaImpuesto: 0, subtotal: 60.00)],
          )),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _abrirFormulario(context),
        backgroundColor: AppColors.secondary,
        foregroundColor: AppColors.white,
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
