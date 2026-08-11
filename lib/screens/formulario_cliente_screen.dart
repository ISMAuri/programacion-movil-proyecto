import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../config/app_text_styles.dart';

class FormularioClienteScreen extends StatefulWidget {
  const FormularioClienteScreen({
    super.key,
    this.nombreCliente,
    this.rtn,
    this.direccion,
    this.telefono,
    this.correo,
  });

  // null en nombreCliente -> modo crear. Con datos -> modo editar.
  final String? nombreCliente;
  final String? rtn;
  final String? direccion;
  final String? telefono;
  final String? correo;

  bool get esEdicion => nombreCliente != null;

  @override
  State<FormularioClienteScreen> createState() =>
      _FormularioClienteScreenState();
}

class _FormularioClienteScreenState extends State<FormularioClienteScreen> {
  late final TextEditingController _nombreController;
  late final TextEditingController _rtnController;
  late final TextEditingController _direccionController;
  late final TextEditingController _telefonoController;
  late final TextEditingController _correoController;

  void _guardarCliente() {
    final nombre = _nombreController.text.trim();
    final rtn = _rtnController.text.trim();
    final direccion = _direccionController.text.trim();
    final telefono = _telefonoController.text.trim();
    final correo = _correoController.text.trim();

    if (nombre.isEmpty ||
        rtn.isEmpty ||
        direccion.isEmpty ||
        telefono.isEmpty ||
        correo.isEmpty) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text("Completa todos los campos del cliente"),
            backgroundColor: AppColors.error,
          ),
        );
      return;
    }

    if (!correo.contains("@") || !correo.contains(".")) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text("Ingresa un correo electrónico válido"),
            backgroundColor: AppColors.error,
          ),
        );
      return;
    }

    final mensaje =
        "Cliente ${widget.esEdicion ? "actualizado" : "creado"} correctamente";

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(mensaje), backgroundColor: AppColors.success),
      );

    Navigator.pop(context, true);
  }

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.nombreCliente ?? "");
    _rtnController = TextEditingController(text: widget.rtn ?? "");
    _direccionController = TextEditingController(text: widget.direccion ?? "");
    _telefonoController = TextEditingController(text: widget.telefono ?? "");
    _correoController = TextEditingController(text: widget.correo ?? "");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          widget.esEdicion ? "Editar cliente" : "Nuevo cliente",
          style: AppTextStyles.screenTitle,
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
      ),
      body: ListView(
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
                children: [
                  TextFormField(
                    controller: _nombreController,
                    decoration: const InputDecoration(
                      labelText: "Nombre del cliente",
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _rtnController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "RTN",
                      prefixIcon: Icon(Icons.badge_outlined),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _direccionController,
                    decoration: const InputDecoration(
                      labelText: "Dirección",
                      prefixIcon: Icon(Icons.location_on_outlined),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _telefonoController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: "Teléfono",
                      prefixIcon: Icon(Icons.phone_outlined),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _correoController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: "Correo",
                      prefixIcon: Icon(Icons.email_outlined),
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
              onPressed: _guardarCliente,
              icon: Icon(widget.esEdicion ? Icons.save_outlined : Icons.add),
              label: Text(
                widget.esEdicion ? "Guardar cambios" : "Crear cliente",
              ),
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
    );
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _rtnController.dispose();
    _direccionController.dispose();
    _telefonoController.dispose();
    _correoController.dispose();
    super.dispose();
  }
}
