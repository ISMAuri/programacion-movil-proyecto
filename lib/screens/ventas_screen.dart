import 'dart:io';

import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import '../config/app_colors.dart';
import '../config/app_text_styles.dart';
import '../models/venta.dart';
import '../services/venta_service.dart';

class VentasScreen extends StatefulWidget {
  const VentasScreen({super.key});

  @override
  State<VentasScreen> createState() => _VentasScreenState();
}

class _VentasScreenState extends State<VentasScreen> {
  final VentaService _ventaService = VentaService();

  bool cargando = true;
  List<Venta> _ventas = [];
  final Set<int> _facturasDescargando = {};

  Future<void> _cargarVentas() async {
    setState(() {
      cargando = true;
    });

    try {
      final response = await _ventaService.getVentas();

      if (!mounted) return;

      setState(() {
        _ventas = response;
        cargando = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        cargando = false;
      });

      _mostrarMensaje('Error al cargar las ventas', color: AppColors.error);
    }
  }

  @override
  void initState() {
    super.initState();
    _cargarVentas();
  }

  Future<void> _abrirFormulario([Venta? venta]) async {
    final resultado = await Navigator.pushNamed(
      context,
      '/formulario_venta',
      arguments: venta,
    );

    if (!mounted || resultado != true) return;

    _mostrarMensaje(
      venta == null
          ? 'Venta registrada correctamente'
          : 'Factura actualizada correctamente',
      color: AppColors.success,
    );

    await _cargarVentas();
  }

  Future<void> _descargarFactura(Venta venta) async {
    if (_facturasDescargando.contains(venta.idVenta)) return;

    setState(() {
      _facturasDescargando.add(venta.idVenta);
    });

    try {
      final directorioBase = await getApplicationDocumentsDirectory();

      final directorioFacturas = Directory('${directorioBase.path}/facturas');

      if (!await directorioFacturas.exists()) {
        await directorioFacturas.create(recursive: true);
      }

      final nombreSeguro = venta.numeroFactura.replaceAll(
        RegExp(r'[^a-zA-Z0-9._-]'),
        '_',
      );

      final rutaPdf = '${directorioFacturas.path}/factura-$nombreSeguro.pdf';

      await _ventaService.descargarFactura(venta.idVenta, rutaPdf);

      if (!mounted) return;

      _mostrarMensaje(
        'Factura descargada correctamente',
        color: AppColors.success,
      );

      final resultado = await OpenFilex.open(rutaPdf);

      if (!mounted) return;

      if (resultado.type != ResultType.done) {
        _mostrarMensaje(
          'La factura se descargó, pero no se pudo abrir automáticamente',
          color: AppColors.error,
        );
      }
    } catch (e) {
      if (!mounted) return;

      _mostrarMensaje('Error al descargar la factura', color: AppColors.error);
    } finally {
      if (mounted) {
        setState(() {
          _facturasDescargando.remove(venta.idVenta);
        });
      }
    }
  }

  void _mostrarMensaje(String mensaje, {Color? color}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(mensaje), backgroundColor: color));
  }

  String _fecha(DateTime fecha) {
    final dia = fecha.day.toString().padLeft(2, '0');
    final mes = fecha.month.toString().padLeft(2, '0');

    return '$dia/$mes/${fecha.year}';
  }

  String _lps(double valor) {
    return 'L. ${valor.toStringAsFixed(2)}';
  }

  Widget _ventaCard(Venta venta) {
    final colorEstado = venta.estadoFactura
        ? AppColors.success
        : AppColors.error;

    final descargando = _facturasDescargando.contains(venta.idVenta);

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
                        venta.caiFactura,
                        style: AppTextStyles.cardTitle.copyWith(fontSize: 14),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        venta.numeroFactura,
                        style: AppTextStyles.cardTitle.copyWith(
                          color: AppColors.primary,
                        ),
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
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
                    onPressed: descargando
                        ? null
                        : () => _descargarFactura(venta),
                    icon: descargando
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.download_outlined),
                    label: Text(descargando ? 'Descargando...' : 'Descargar'),
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

  Widget _contenido() {
    if (cargando) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_ventas.isEmpty) {
      return Center(
        child: Text(
          'No hay ventas registradas.',
          style: AppTextStyles.subtitle,
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _cargarVentas,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: _ventas.length,
        itemBuilder: (context, index) {
          return _ventaCard(_ventas[index]);
        },
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
        actions: [
          IconButton(
            onPressed: _cargarVentas,
            icon: const Icon(Icons.refresh),
            tooltip: 'Actualizar ventas',
          ),
        ],
      ),
      backgroundColor: AppColors.background,
      body: _contenido(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _abrirFormulario(),
        backgroundColor: AppColors.secondary,
        foregroundColor: AppColors.white,
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
