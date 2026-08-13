import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../config/app_text_styles.dart';
import '../models/detalle_venta_model.dart';
import '../models/venta_model.dart';

class VentasScreen extends StatefulWidget {
  const VentasScreen({super.key});

  @override
  State<VentasScreen> createState() => _VentasScreenState();
}

class _VentasScreenState extends State<VentasScreen> {
  late final List<Venta> _ventas = [
    _ventaEjemplo(
      idVenta: 1,
      correlativo: 1,
      cliente: 'Supermercado La Colonia',
      fecha: DateTime(2026, 8, 5, 10, 30),
      producto: 'Aceite vegetal 1 L',
      total: 575.00,
      tasa: 15,
      metodoPago: 'Efectivo',
    ),
    _ventaEjemplo(
      idVenta: 2,
      correlativo: 2,
      cliente: 'Distribuidora El Sol S.A.',
      fecha: DateTime(2026, 8, 6, 14, 15),
      producto: 'Bebida gaseosa',
      total: 1150.00,
      tasa: 15,
      metodoPago: 'Transferencia',
    ),
    _ventaEjemplo(
      idVenta: 3,
      correlativo: 3,
      cliente: 'Mini Market La Esquina',
      fecha: DateTime(2026, 8, 7, 9, 0),
      producto: 'Pan francés (docena)',
      total: 140.00,
      tasa: 0,
      metodoPago: 'Efectivo',
      estadoFactura: false,
    ),
  ];

  static Venta _ventaEjemplo({
    required int idVenta,
    required int correlativo,
    required String cliente,
    required DateTime fecha,
    required String producto,
    required double total,
    required double tasa,
    required String metodoPago,
    bool estadoFactura = true,
  }) {
    final base = tasa == 0 ? total : total / (1 + tasa / 100);
    final impuesto = total - base;
    final numero = correlativo.toString().padLeft(8, '0');

    return Venta(
      idVenta: idVenta,
      idCliente: idVenta + 4,
      idUsuario: 1,
      usuarioNombreFactura: 'Administrador',
      idAutorizacion: 1,
      numeroFactura: '000-001-01-$numero',
      correlativo: correlativo,
      caiFactura: '3C18C3-8C69E3-1BE5E0-63BE03-0909BF-A0',
      rangoInicialFactura: '000-001-01-00000001',
      rangoFinalFactura: '000-001-01-00005000',
      fechaLimiteEmisionFactura: DateTime(2027, 7, 12),
      empresaNombreFactura: 'Inversiones Sammy',
      empresaRazonSocialFactura: 'Inversiones Sammy',
      empresaRtnFactura: '01079016892580',
      empresaDireccionFactura:
          'Los Fuertes contiguo al Super Olguita, Roatan, Islas de la Bahia',
      empresaTelefonoFactura: '97547973',
      empresaCorreoFactura: 'inversionesammy2019@hotmail.com',
      clienteNombreFactura: cliente,
      fechaVenta: fecha,
      subtotal: base,
      totalExento: tasa == 0 ? base : 0,
      totalGravado15: tasa == 15 ? base : 0,
      totalGravado18: tasa == 18 ? base : 0,
      totalIsv15: tasa == 15 ? impuesto : 0,
      totalIsv18: tasa == 18 ? impuesto : 0,
      total: total,
      totalLetras: '${total.toStringAsFixed(2)} LEMPIRAS',
      estadoFactura: estadoFactura,
      metodoPago: metodoPago,
      detalles: [
        DetalleVenta(
          idDetalleVenta: idVenta,
          idVenta: idVenta,
          idProducto: idVenta,
          productoCodigoFactura: 'PRO-${idVenta.toString().padLeft(3, '0')}',
          productoNombreFactura: producto,
          productoUnidadMedidaFactura: 'Unidad',
          productoTasaImpuestoFactura: tasa,
          cantidad: 1,
          precioUnitario: base,
          subtotal: base,
          baseGravada: tasa > 0 ? base : 0,
          baseExenta: tasa == 0 ? base : 0,
          montoImpuesto: impuesto,
        ),
      ],
    );
  }

  Future<void> _abrirFormulario([Venta? venta]) async {
    final resultado = await Navigator.pushNamed(
      context,
      '/formulario_venta',
      arguments: venta,
    );

    if (!mounted || resultado is! Venta) return;

    setState(() {
      final indice = resultado.idVenta == null
          ? -1
          : _ventas.indexWhere(
              (item) => item.idVenta == resultado.idVenta,
            );
      if (indice >= 0) {
        _ventas[indice] = resultado;
      } else {
        _ventas.insert(0, resultado);
      }
    });

    final fueAnulada = venta != null &&
        venta.estadoFactura &&
        !resultado.estadoFactura;
    _mostrarMensaje(
      fueAnulada
          ? 'Factura anulada correctamente'
          : 'Venta registrada correctamente',
      color: fueAnulada ? AppColors.error : AppColors.success,
    );
  }

  void _descargarFactura(Venta venta) {
    _mostrarMensaje(
      'La descarga de la factura ${venta.numeroFactura} se habilitará con el backend.',
    );
  }

  void _mostrarMensaje(String mensaje, {Color? color}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(mensaje),
          backgroundColor: color,
        ),
      );
  }

  String _fecha(DateTime fecha) {
    final dia = fecha.day.toString().padLeft(2, '0');
    final mes = fecha.month.toString().padLeft(2, '0');
    return '$dia/$mes/${fecha.year}';
  }

  String _lps(double valor) => 'L. ${valor.toStringAsFixed(2)}';

  Widget _ventaCard(Venta venta) {
    final colorEstado =
        venta.estadoFactura ? AppColors.success : AppColors.error;

    return Card(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      color: AppColors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        venta.numeroFactura,
                        style: AppTextStyles.cardTitle,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        venta.clienteNombreFactura,
                        style: AppTextStyles.subtitle,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: colorEstado.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    venta.estadoFactura ? 'Emitida' : 'Anulada',
                    style: TextStyle(
                      color: colorEstado,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.calendar_today_outlined, size: 18),
                const SizedBox(width: 6),
                Text(_fecha(venta.fechaVenta)),
                const Spacer(),
                Text(_lps(venta.total), style: AppTextStyles.price),
              ],
            ),
            const Divider(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _abrirFormulario(venta),
                    icon: const Icon(Icons.visibility_outlined),
                    label: const Text('Ver datos'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _descargarFactura(venta),
                    icon: const Icon(Icons.download_outlined),
                    label: const Text('Descargar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ventas', style: AppTextStyles.screenTitle),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
      ),
      backgroundColor: AppColors.background,
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: _ventas.length,
        itemBuilder: (context, index) => _ventaCard(_ventas[index]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _abrirFormulario,
        backgroundColor: AppColors.secondary,
        foregroundColor: AppColors.white,
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
