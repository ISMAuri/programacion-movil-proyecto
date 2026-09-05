import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../config/app_colors.dart';
import '../config/app_text_styles.dart';
import '../models/autorizacion_factura.dart';
import '../services/autorizacion_factura_service.dart';
import '../widgets/estado_badge.dart';
import '../widgets/aviso_card.dart';

class FormularioDatosFiscalesScreen extends StatefulWidget {
  const FormularioDatosFiscalesScreen({super.key});

  @override
  State<FormularioDatosFiscalesScreen> createState() =>
      _FormularioDatosFiscalesScreenState();
}

class _FormularioDatosFiscalesScreenState
    extends State<FormularioDatosFiscalesScreen> {
  final _formKey = GlobalKey<FormState>();

  // Solo hay una empresa en el sistema.
  final int _idEmpresa = 1;

  final AutorizacionFacturaService _autorizacionFacturaService =
      AutorizacionFacturaService();

  bool cargando = true;

  late final TextEditingController _caiController = TextEditingController();

  late final TextEditingController _establecimientoController =
      TextEditingController();

  late final TextEditingController _puntoEmisionController =
      TextEditingController();

  late final TextEditingController _tipoDocumentoController =
      TextEditingController();

  late final TextEditingController _rangoInicialController =
      TextEditingController();

  late final TextEditingController _rangoFinalController =
      TextEditingController();

  late final TextEditingController _siguienteCorrelativoController =
      TextEditingController();

  DateTime _fechaAutorizacion = DateTime.now();
  DateTime _fechaLimiteEmision = DateTime.now();

  Future<void> _cargarAutorizacion() async {
    try {
      final autorizacion = await _autorizacionFacturaService
          .getAutorizacionActivaEmpresa(_idEmpresa);

      if (!mounted) return;

      setState(() {
        _caiController.text = autorizacion.cai;

        _establecimientoController.text = autorizacion.establecimiento;

        _puntoEmisionController.text = autorizacion.puntoEmision;

        _tipoDocumentoController.text = autorizacion.tipoDocumento;

        _rangoInicialController.text = autorizacion.rangoInicial.toString();

        _rangoFinalController.text = autorizacion.rangoFinal.toString();

        _siguienteCorrelativoController.text = autorizacion.siguienteCorrelativo
            .toString();

        _fechaAutorizacion = autorizacion.fechaAutorizacion;

        _fechaLimiteEmision = autorizacion.fechaLimiteEmision;

        cargando = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        cargando = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Error al cargar los datos de autorización fiscal',
          ),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;

    final rangoInicial = int.parse(_rangoInicialController.text.trim());

    final rangoFinal = int.parse(_rangoFinalController.text.trim());

    if (rangoFinal < rangoInicial) {
      _mostrarError('El rango final no puede ser menor que el rango inicial');
      return;
    }

    if (_fechaLimiteEmision.isBefore(_fechaAutorizacion)) {
      _mostrarError(
        'La fecha límite de emisión no puede ser anterior a la fecha de autorización',
      );
      return;
    }

    final autorizacion = AutorizacionFactura(
      idEmpresa: _idEmpresa,
      cai: _caiController.text.trim(),
      establecimiento: _establecimientoController.text.trim(),
      puntoEmision: _puntoEmisionController.text.trim(),
      tipoDocumento: _tipoDocumentoController.text.trim(),
      rangoInicial: rangoInicial,
      rangoFinal: rangoFinal,

      // Al crear una nueva autorización,
      // el correlativo empieza en el rango inicial.
      siguienteCorrelativo: rangoInicial,

      fechaAutorizacion: _fechaAutorizacion,
      fechaLimiteEmision: _fechaLimiteEmision,
      estado: true,
    );

    try {
      await _autorizacionFacturaService.postAutorizacion(autorizacion);

      if (!mounted) return;

      Navigator.pop(context, true);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Datos de autorización fiscal guardados correctamente'),
          backgroundColor: AppColors.success,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      _mostrarError('Error al guardar los datos de autorización fiscal: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _cargarAutorizacion();
  }

  void _mostrarError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje), backgroundColor: AppColors.error),
    );
  }

  Future<void> _seleccionarFecha({required bool esAutorizacion}) async {
    final fechaActual = esAutorizacion
        ? _fechaAutorizacion
        : _fechaLimiteEmision;

    final fecha = await showDatePicker(
      context: context,
      initialDate: fechaActual,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (fecha != null) {
      setState(() {
        if (esAutorizacion) {
          _fechaAutorizacion = fecha;
        } else {
          _fechaLimiteEmision = fecha;
        }
      });
    }
  }

  String _formatearFecha(DateTime fecha) {
    final dia = fecha.day.toString().padLeft(2, '0');

    final mes = fecha.month.toString().padLeft(2, '0');

    return '$dia/$mes/${fecha.year}';
  }

  String? _validarRequerido(String? valor, String mensaje) {
    return valor == null || valor.trim().isEmpty ? mensaje : null;
  }

  String? _validarNumero(String? valor, String nombre) {
    if (valor == null || valor.trim().isEmpty) {
      return 'Ingresa $nombre';
    }

    final numero = int.tryParse(valor);

    if (numero == null || numero < 1) {
      return 'Ingresa un número válido';
    }

    return null;
  }

  Widget _campoTexto({
    required TextEditingController controller,
    required String etiqueta,
    required IconData icono,
    bool habilitado = true,
    TextInputType? teclado,
    List<TextInputFormatter>? filtros,
    int? longitudMaxima,
    String? textoInformativo,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      enabled: habilitado,
      keyboardType: teclado,
      inputFormatters: filtros,
      maxLength: longitudMaxima,
      decoration: InputDecoration(
        labelText: etiqueta,
        prefixIcon: Icon(icono),
        helperText: textoInformativo,
        counterText: '',
      ),
      validator: validator,
    );
  }

  Widget _campoFecha({
    required String etiqueta,
    required IconData icono,
    required DateTime fecha,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: etiqueta,
          prefixIcon: Icon(icono),
        ),
        child: Text(_formatearFecha(fecha)),
      ),
    );
  }

  Widget _tarjeta({required String titulo, required List<Widget> children}) {
    return Card(
      elevation: 2,
      color: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(titulo, style: AppTextStyles.sectionTitle),
            const SizedBox(height: 14),
            ...children,
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const separador = SizedBox(height: 14);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Datos fiscales', style: AppTextStyles.screenTitle),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
      ),
      body: Form(
        key: _formKey,
        child: cargando
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  AvisoCard(
                    text:
                        'Importante: Estos datos no deben modificarse salvo que se haya emitido una nueva autorización. Al guardar cambios se creará un nuevo registro y la anterior se conservará en el historial.',
                  ),
                  const SizedBox(height: 16),
                  _tarjeta(
                    titulo: 'Autorización fiscal',
                    children: [
                      _campoTexto(
                        controller: _caiController,
                        etiqueta: 'CAI',
                        icono: Icons.receipt_long_outlined,
                        longitudMaxima: 50,
                        textoInformativo:
                            '37 caracteres (6-6-6-6-6-2 separados por guiones)',
                        validator: (valor) =>
                            _validarRequerido(valor, 'Ingresa el CAI'),
                      ),
                      separador,
                      _campoTexto(
                        controller: _establecimientoController,
                        etiqueta: 'Número de establecimiento',
                        icono: Icons.store_outlined,
                        habilitado: false,
                      ),
                      separador,
                      _campoTexto(
                        controller: _puntoEmisionController,
                        etiqueta: 'Punto de emisión',
                        icono: Icons.point_of_sale_outlined,
                        habilitado: false,
                      ),
                      separador,
                      _campoTexto(
                        controller: _tipoDocumentoController,
                        etiqueta: 'Tipo de documento',
                        icono: Icons.description_outlined,
                        habilitado: false,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _tarjeta(
                    titulo: 'Rango autorizado',
                    children: [
                      _campoTexto(
                        controller: _rangoInicialController,
                        etiqueta: 'Rango inicial',
                        icono: Icons.format_list_numbered,
                        teclado: TextInputType.number,
                        filtros: [FilteringTextInputFormatter.digitsOnly],
                        validator: (valor) =>
                            _validarNumero(valor, 'el rango inicial'),
                      ),
                      separador,
                      _campoTexto(
                        controller: _rangoFinalController,
                        etiqueta: 'Rango final',
                        icono: Icons.format_list_numbered,
                        teclado: TextInputType.number,
                        filtros: [FilteringTextInputFormatter.digitsOnly],
                        validator: (valor) =>
                            _validarNumero(valor, 'el rango final'),
                      ),
                      separador,
                      _campoTexto(
                        controller: _siguienteCorrelativoController,
                        etiqueta: 'Siguiente número correlativo',
                        icono: Icons.numbers,
                        habilitado: false,
                        textoInformativo: 'Este valor lo controla el sistema.',
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _tarjeta(
                    titulo: 'Vigencia',
                    children: [
                      _campoFecha(
                        etiqueta: 'Fecha de autorización',
                        icono: Icons.calendar_today_outlined,
                        fecha: _fechaAutorizacion,
                        onTap: () => _seleccionarFecha(esAutorizacion: true),
                      ),
                      separador,
                      _campoFecha(
                        etiqueta: 'Fecha límite de emisión',
                        icono: Icons.event_available_outlined,
                        fecha: _fechaLimiteEmision,
                        onTap: () => _seleccionarFecha(esAutorizacion: false),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  EstadoBadge(
                    estado: _fechaLimiteEmision.isAfter(DateTime.now()),
                    textoActivo: 'Vigente',
                    textoInactivo: 'Vencido',
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: _guardar,
                      icon: const Icon(Icons.save_outlined),
                      label: const Text('Guardar cambios'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                ],
              ),
      ),
    );
  }

  @override
  void dispose() {
    _caiController.dispose();
    _establecimientoController.dispose();
    _puntoEmisionController.dispose();
    _tipoDocumentoController.dispose();
    _rangoInicialController.dispose();
    _rangoFinalController.dispose();
    _siguienteCorrelativoController.dispose();

    super.dispose();
  }
}
