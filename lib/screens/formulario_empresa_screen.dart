import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../config/app_text_styles.dart';
import '../models/empresa_model.dart';

class FormularioEmpresaScreen extends StatefulWidget {
  const FormularioEmpresaScreen({super.key, this.empresa});

  // Pantalla siempre en modo edición
  final Empresa? empresa;

  @override
  State<FormularioEmpresaScreen> createState() =>
      _FormularioEmpresaScreenState();
}

class _FormularioEmpresaScreenState extends State<FormularioEmpresaScreen> {
  final _formKey = GlobalKey<FormState>();

  late final Empresa _empresaInicial;
  late final TextEditingController _nombreController;
  late final TextEditingController _razonSocialController;
  late final TextEditingController _rtnController;
  late final TextEditingController _direccionController;
  late final TextEditingController _telefonoController;
  late final TextEditingController _correoController;

  @override
  void initState() {
    super.initState();

    _empresaInicial =
        widget.empresa ??
        Empresa(
          idEmpresa: 1,
          nombreEmpresa: "Inversiones Sammy",
          razonSocial: "Inversiones Sammy",
          rtn: "01079016892580",
          direccion:
              "Los Fuertes contiguo al Super Olguita, Roatan, Islas de la Bahia",
          telefono: "97547973",
          correo: "inversionesammy2019@hotmail.com",
        );

    _nombreController = TextEditingController(
      text: _empresaInicial.nombreEmpresa,
    );
    _razonSocialController = TextEditingController(
      text: _empresaInicial.razonSocial ?? "",
    );
    _rtnController = TextEditingController(text: _empresaInicial.rtn ?? "");
    _direccionController = TextEditingController(
      text: _empresaInicial.direccion ?? "",
    );
    _telefonoController = TextEditingController(
      text: _empresaInicial.telefono ?? "",
    );
    _correoController = TextEditingController(
      text: _empresaInicial.correo ?? "",
    );
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _razonSocialController.dispose();
    _rtnController.dispose();
    _direccionController.dispose();
    _telefonoController.dispose();
    _correoController.dispose();
    super.dispose();
  }

  void _guardar() {
    if (!_formKey.currentState!.validate()) return;

    final empresaActualizada = Empresa(
      idEmpresa: _empresaInicial.idEmpresa,
      nombreEmpresa: _nombreController.text.trim(),
      razonSocial: _valorOpcional(_razonSocialController.text),
      rtn: _valorOpcional(_rtnController.text),
      direccion: _valorOpcional(_direccionController.text),
      telefono: _valorOpcional(_telefonoController.text),
      correo: _valorOpcional(_correoController.text),
      logo: _empresaInicial.logo,
    );

    Navigator.pop(context, empresaActualizada);
  }

  String? _valorOpcional(String valor) {
    final texto = valor.trim();
    return texto.isEmpty ? null : texto;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text("Datos de la empresa", style: AppTextStyles.screenTitle),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const SizedBox(height: 20),

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
                      "Información general",
                      style: AppTextStyles.sectionTitle,
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _nombreController,
                      decoration: const InputDecoration(
                        labelText: "Nombre comercial",
                        prefixIcon: Icon(Icons.storefront_outlined),
                      ),
                      validator: (valor) =>
                          (valor == null || valor.trim().isEmpty)
                          ? "Ingresa el nombre de la empresa"
                          : null,
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _razonSocialController,
                      decoration: const InputDecoration(
                        labelText: "Razón social",
                        prefixIcon: Icon(Icons.business_outlined),
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
                    Text("Contacto", style: AppTextStyles.sectionTitle),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _direccionController,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        labelText: "Dirección",
                        alignLabelWithHint: true,
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
                        labelText: "Correo electrónico",
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                      validator: (valor) {
                        if (valor == null || valor.trim().isEmpty) return null;
                        if (!valor.contains("@")) return "Correo inválido";
                        return null;
                      },
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
