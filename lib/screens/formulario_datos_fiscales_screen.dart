import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../config/app_colors.dart';
import '../config/app_text_styles.dart';
import '../models/autorizacion_factura_model.dart';

class FormularioDatosFiscalesScreen extends StatefulWidget {
  const FormularioDatosFiscalesScreen({super.key, this.autorizacion});

  final AutorizacionFactura? autorizacion;

  @override
  State<FormularioDatosFiscalesScreen> createState() =>
      _FormularioDatosFiscalesScreenState();
}

class _FormularioDatosFiscalesScreenState
    extends State<FormularioDatosFiscalesScreen> {
  final _formKey = GlobalKey<FormState>();

  late final AutorizacionFactura _datosIniciales;
  late final TextEditingController _caiController;
  late final TextEditingController _establecimientoController;
  late final TextEditingController _puntoEmisionController;
  late final TextEditingController _tipoDocumentoController;
  late final TextEditingController _rangoInicialController;
  late final TextEditingController _rangoFinalController;
  late final TextEditingController _siguienteCorrelativoController;

  late DateTime _fechaAutorizacion;
  late DateTime _fechaLimiteEmision;
  late bool _estado;

  @override
  void initState() {
    super.initState();

    _datosIniciales =
        widget.autorizacion ??
        AutorizacionFactura(
          idAutorizacion: 1,
          idEmpresa: 1,
          cai: '3C18C3-8C69E3-1BE5E0-63BE03-0909BF-A0',
          establecimiento: '000',
          puntoEmision: '001',
          tipoDocumento: '01',
          rangoInicial: 1,
          rangoFinal: 5000,
          siguienteCorrelativo: 1,
          fechaAutorizacion: DateTime(2026, 7, 12),
          fechaLimiteEmision: DateTime(2027, 7, 12),
          estado: true,
        );

    _caiController = TextEditingController(text: _datosIniciales.cai);
    _establecimientoController = TextEditingController(
      text: _datosIniciales.establecimiento,
    );
    _puntoEmisionController = TextEditingController(
      text: _datosIniciales.puntoEmision,
    );
    _tipoDocumentoController = TextEditingController(
      text: _datosIniciales.tipoDocumento,
    );
    _rangoInicialController = TextEditingController(
      text: _datosIniciales.rangoInicial.toString(),
    );
    _rangoFinalController = TextEditingController(
      text: _datosIniciales.rangoFinal.toString(),
    );
    _siguienteCorrelativoController = TextEditingController(
      text: _datosIniciales.siguienteCorrelativo.toString(),
    );
    _fechaAutorizacion = _datosIniciales.fechaAutorizacion;
    _fechaLimiteEmision = _datosIniciales.fechaLimiteEmision;
    _estado = _datosIniciales.estado;
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

  void _guardar() {
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

    final autorizacionActualizada = AutorizacionFactura(
      idAutorizacion: _datosIniciales.idAutorizacion,
      idEmpresa: _datosIniciales.idEmpresa,
      cai: _caiController.text.trim(),
      establecimiento: _establecimientoController.text,
      puntoEmision: _puntoEmisionController.text.trim(),
      tipoDocumento: _tipoDocumentoController.text.trim(),
      rangoInicial: rangoInicial,
      rangoFinal: rangoFinal,
      siguienteCorrelativo: _datosIniciales.siguienteCorrelativo,
      fechaAutorizacion: _fechaAutorizacion,
      fechaLimiteEmision: _fechaLimiteEmision,
      estado: _estado,
    );

    Navigator.pop(context, autorizacionActualizada);
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
    if (valor == null || valor.trim().isEmpty) return 'Ingresa $nombre';
    final numero = int.tryParse(valor);
    if (numero == null || numero < 1) return 'Ingresa un número válido';
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
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
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
                  validator: (valor) => _validarNumero(valor, 'el rango final'),
                ),
                separador,
                _campoTexto(
                  controller: _siguienteCorrelativoController,
                  etiqueta: 'Siguiente número correlativo',
                  icono: Icons.numbers,
                  habilitado: false,
                  textoInformativo:
                      'Se establece solo al crear una nueva configuración.',
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
                separador,
                SwitchListTile.adaptive(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Autorización activa'),
                  subtitle: Text(_estado ? 'Activa' : 'Inactiva'),
                  value: _estado,
                  activeColor: AppColors.primary,
                  onChanged: (valor) => setState(() => _estado = valor),
                ),
              ],
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
}
