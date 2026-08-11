import 'package:flutter/material.dart';

import '../config/app_colors.dart';
import '../config/app_text_styles.dart';

class FormularioDatosFiscalesScreen extends StatefulWidget {
  const FormularioDatosFiscalesScreen({
    super.key,
    this.cai,
    this.rangoInicial,
    this.rangoFinal,
    this.fechaAutorizacion,
    this.fechaLimiteEmision,
  });

  // Pantalla siempre en modo edición: cada empresa tiene una
  // configuración fiscal asociada.
  final String? cai;
  final String? rangoInicial;
  final String? rangoFinal;
  final DateTime? fechaAutorizacion;
  final DateTime? fechaLimiteEmision;

  @override
  State<FormularioDatosFiscalesScreen> createState() =>
      _FormularioDatosFiscalesScreenState();
}

class _FormularioDatosFiscalesScreenState
    extends State<FormularioDatosFiscalesScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _caiController;
  late final TextEditingController _rangoInicialController;
  late final TextEditingController _rangoFinalController;

  DateTime? _fechaAutorizacion;
  DateTime? _fechaLimiteEmision;

  @override
  void initState() {
    super.initState();

    _caiController = TextEditingController(text: widget.cai ?? "");

    _rangoInicialController = TextEditingController(
      text: widget.rangoInicial ?? "",
    );

    _rangoFinalController = TextEditingController(
      text: widget.rangoFinal ?? "",
    );

    _fechaAutorizacion = widget.fechaAutorizacion;
    _fechaLimiteEmision = widget.fechaLimiteEmision;
  }

  @override
  void dispose() {
    _caiController.dispose();
    _rangoInicialController.dispose();
    _rangoFinalController.dispose();

    super.dispose();
  }

  void _guardar() {
    if (!_formKey.currentState!.validate()) return;

    if (_fechaAutorizacion == null) {
      _mostrarError("Selecciona la fecha de autorización");
      return;
    }

    if (_fechaLimiteEmision == null) {
      _mostrarError("Selecciona la fecha límite de emisión");
      return;
    }

    if (_fechaLimiteEmision!.isBefore(_fechaAutorizacion!)) {
      _mostrarError(
        "La fecha límite de emisión no puede ser anterior "
        "a la fecha de autorización",
      );
      return;
    }

    // Validar y guardar los datos fiscales
  }

  void _mostrarError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: AppColors.error,
      ),
    );
  }

  Future<void> _seleccionarFechaAutorizacion() async {
    final fecha = await showDatePicker(
      context: context,
      initialDate: _fechaAutorizacion ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (fecha != null) {
      setState(() {
        _fechaAutorizacion = fecha;
      });
    }
  }

  Future<void> _seleccionarFechaLimiteEmision() async {
    final fecha = await showDatePicker(
      context: context,
      initialDate: _fechaLimiteEmision ??
          _fechaAutorizacion ??
          DateTime.now(),
      firstDate: _fechaAutorizacion ?? DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (fecha != null) {
      setState(() {
        _fechaLimiteEmision = fecha;
      });
    }
  }

  String _formatearFecha(DateTime? fecha) {
    if (fecha == null) return "";

    final dia = fecha.day.toString().padLeft(2, '0');
    final mes = fecha.month.toString().padLeft(2, '0');
    final anio = fecha.year.toString();

    return "$dia/$mes/$anio";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          "Datos fiscales",
          style: AppTextStyles.screenTitle,
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Card(
              elevation: 2,
              color: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Autorización fiscal",
                      style: AppTextStyles.sectionTitle,
                    ),

                    const SizedBox(height: 14),

                    TextFormField(
                      controller: _caiController,
                      decoration: const InputDecoration(
                        labelText: "CAI",
                        prefixIcon: Icon(Icons.receipt_long_outlined),
                      ),
                      validator: (valor) =>
                          (valor == null || valor.trim().isEmpty)
                              ? "Ingresa el CAI"
                              : null,
                    ),

                    const SizedBox(height: 14),

                    TextFormField(
                      controller: _rangoInicialController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Rango inicial",
                        prefixIcon: Icon(Icons.format_list_numbered),
                      ),
                      validator: (valor) =>
                          (valor == null || valor.trim().isEmpty)
                              ? "Ingresa el rango inicial"
                              : null,
                    ),

                    const SizedBox(height: 14),

                    TextFormField(
                      controller: _rangoFinalController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Rango final",
                        prefixIcon: Icon(Icons.format_list_numbered),
                      ),
                      validator: (valor) =>
                          (valor == null || valor.trim().isEmpty)
                              ? "Ingresa el rango final"
                              : null,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            Card(
              elevation: 2,
              color: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Vigencia",
                      style: AppTextStyles.sectionTitle,
                    ),

                    const SizedBox(height: 14),

                    InkWell(
                      onTap: _seleccionarFechaAutorizacion,
                      borderRadius: BorderRadius.circular(12),
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: "Fecha de autorización",
                          prefixIcon: Icon(Icons.calendar_today_outlined),
                        ),
                        child: Text(
                          _fechaAutorizacion != null
                              ? _formatearFecha(_fechaAutorizacion)
                              : "Seleccionar fecha",
                          style: _fechaAutorizacion != null
                              ? null
                              : AppTextStyles.subtitle,
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    InkWell(
                      onTap: _seleccionarFechaLimiteEmision,
                      borderRadius: BorderRadius.circular(12),
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: "Fecha límite de emisión",
                          prefixIcon: Icon(
                            Icons.event_available_outlined,
                          ),
                        ),
                        child: Text(
                          _fechaLimiteEmision != null
                              ? _formatearFecha(_fechaLimiteEmision)
                              : "Seleccionar fecha",
                          style: _fechaLimiteEmision != null
                              ? null
                              : AppTextStyles.subtitle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _guardar,
                icon: const Icon(Icons.save_outlined),
                label: const Text("Guardar cambios"),
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