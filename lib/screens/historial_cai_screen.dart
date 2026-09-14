import 'package:flutter/material.dart';

import '../config/app_colors.dart';
import '../config/app_text_styles.dart';
import '../models/autorizacion_factura.dart';
import '../services/autorizacion_factura_service.dart';
import '../widgets/estado_badge.dart';

class HistorialCaiScreen extends StatefulWidget {
  const HistorialCaiScreen({super.key});

  @override
  State<HistorialCaiScreen> createState() => _HistorialCaiScreenState();
}

class _HistorialCaiScreenState extends State<HistorialCaiScreen> {
  final AutorizacionFacturaService _service = AutorizacionFacturaService();

  final int _idEmpresa = 1;

  AutorizacionFactura? _vigente;
  List<AutorizacionFactura> _anteriores = [];

  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    setState(() {
      _cargando = true;
    });

    try {
      final vigente = await _service.getAutorizacionActivaEmpresa(_idEmpresa);

      final anteriores = await _service.getAutorizacionesAnterioresEmpresa(
        _idEmpresa,
      );

      // Ordenar las autorizaciones anteriores por idAutorizacion en orden descendente
      anteriores.sort((a, b) => b.idAutorizacion!.compareTo(a.idAutorizacion!));

      if (!mounted) return;

      setState(() {
        _vigente = vigente;
        _anteriores = anteriores;
        _cargando = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _cargando = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Error al cargar el historial de CAI'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  String _formatearFecha(DateTime fecha) {
    final dia = fecha.day.toString().padLeft(2, '0');
    final mes = fecha.month.toString().padLeft(2, '0');

    return '$dia/$mes/${fecha.year}';
  }

  Widget _dato({
    required IconData icono,
    required String titulo,
    required String valor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icono, size: 20, color: AppColors.secondary),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: AppTextStyles.subtitle.copyWith(fontSize: 12),
                ),
                const SizedBox(height: 2),
                Text(
                  valor,
                  style: AppTextStyles.cardTitle.copyWith(fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _tarjetaAutorizacion(
    AutorizacionFactura autorizacion, {
    required bool vigente,
  }) {
    return Card(
      elevation: vigente ? 3 : 2,
      color: AppColors.white,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: AppColors.white,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
            ),
            builder: (context) {
              return Padding(
                padding: const EdgeInsets.all(22),
                child: SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              vigente ? 'CAI vigente' : 'Autorización anterior',
                              style: AppTextStyles.sectionTitle,
                            ),
                          ),
                          EstadoBadge(
                            estado: vigente,
                            textoActivo: 'Vigente',
                            textoInactivo: 'Finalizado',
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _dato(
                        icono: Icons.receipt_long_outlined,
                        titulo: 'CAI',
                        valor: autorizacion.cai,
                      ),
                      _dato(
                        icono: Icons.store_outlined,
                        titulo: 'Establecimiento',
                        valor: autorizacion.establecimiento,
                      ),
                      _dato(
                        icono: Icons.point_of_sale_outlined,
                        titulo: 'Punto de emisión',
                        valor: autorizacion.puntoEmision,
                      ),
                      _dato(
                        icono: Icons.description_outlined,
                        titulo: 'Tipo de documento',
                        valor: autorizacion.tipoDocumento,
                      ),
                      _dato(
                        icono: Icons.format_list_numbered,
                        titulo: 'Rango autorizado',
                        valor:
                            '${autorizacion.rangoInicial} - ${autorizacion.rangoFinal}',
                      ),
                      _dato(
                        icono: Icons.numbers,
                        titulo: 'Siguiente correlativo',
                        valor: autorizacion.siguienteCorrelativo.toString(),
                      ),
                      _dato(
                        icono: Icons.calendar_today_outlined,
                        titulo: 'Fecha de autorización',
                        valor: _formatearFecha(autorizacion.fechaAutorizacion),
                      ),
                      _dato(
                        icono: Icons.event_available_outlined,
                        titulo: 'Fecha límite de emisión',
                        valor: _formatearFecha(autorizacion.fechaLimiteEmision),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: vigente
                      ? AppColors.success.withOpacity(0.1)
                      : AppColors.disabled.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(
                  Icons.receipt_long_outlined,
                  color: vigente ? AppColors.success : AppColors.disabled,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      vigente ? 'CAI vigente' : 'Autorización anterior',
                      style: AppTextStyles.cardTitle,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      autorizacion.cai,
                      style: AppTextStyles.subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Rango: ${autorizacion.rangoInicial} — ${autorizacion.rangoFinal}',
                      style: AppTextStyles.subtitle.copyWith(fontSize: 12),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${_formatearFecha(autorizacion.fechaAutorizacion)} — '
                      '${_formatearFecha(autorizacion.fechaLimiteEmision)}',
                      style: AppTextStyles.subtitle.copyWith(fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                children: [
                  EstadoBadge(
                    estado: vigente,
                    textoActivo: 'Vigente',
                    textoInactivo: 'Finalizado',
                  ),
                  const SizedBox(height: 6),
                  Icon(Icons.chevron_right, color: AppColors.disabled),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Historial de CAI', style: AppTextStyles.screenTitle),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        actions: [
          IconButton(
            onPressed: _cargarDatos,
            icon: const Icon(Icons.refresh),
            tooltip: 'Actualizar historial',
          ),
        ],
      ),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _cargarDatos,
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  if (_vigente != null) ...[
                    Text(
                      'Autorización actual',
                      style: AppTextStyles.sectionTitle,
                    ),
                    const SizedBox(height: 12),
                    _tarjetaAutorizacion(_vigente!, vigente: true),
                    const SizedBox(height: 14),
                  ],

                  Text('Historial', style: AppTextStyles.sectionTitle),
                  const SizedBox(height: 12),

                  if (_anteriores.isEmpty)
                    Card(
                      elevation: 1,
                      color: AppColors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            Icon(
                              Icons.history_outlined,
                              size: 42,
                              color: AppColors.disabled,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'No hay autorizaciones anteriores',
                              style: AppTextStyles.cardTitle,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Aquí aparecerán los CAI anteriores cuando se registre una nueva autorización.',
                              style: AppTextStyles.subtitle,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    ..._anteriores.map(
                      (autorizacion) =>
                          _tarjetaAutorizacion(autorizacion, vigente: false),
                    ),

                  const SizedBox(height: 10),
                ],
              ),
            ),
    );
  }
}
