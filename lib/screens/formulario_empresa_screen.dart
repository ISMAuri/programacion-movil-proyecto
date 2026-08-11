import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../config/app_text_styles.dart';

class FormularioEmpresaScreen extends StatefulWidget {
  const FormularioEmpresaScreen({
    super.key,
    this.nombreEmpresa,
    this.razonSocial,
    this.rtn,
    this.direccion,
    this.telefono,
    this.correo,
    this.logoUrl,
  });

  // Pantalla siempre en modo edición: cada empresa tiene un único registro.
  final String? nombreEmpresa;
  final String? razonSocial;
  final String? rtn;
  final String? direccion;
  final String? telefono;
  final String? correo;
  final String? logoUrl;

  @override
  State<FormularioEmpresaScreen> createState() =>
      _FormularioEmpresaScreenState();
}

class _FormularioEmpresaScreenState extends State<FormularioEmpresaScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nombreController;
  late final TextEditingController _razonSocialController;
  late final TextEditingController _rtnController;
  late final TextEditingController _direccionController;
  late final TextEditingController _telefonoController;
  late final TextEditingController _correoController;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.nombreEmpresa ?? "");
    _razonSocialController = TextEditingController(
      text: widget.razonSocial ?? "",
    );
    _rtnController = TextEditingController(text: widget.rtn ?? "");
    _direccionController = TextEditingController(text: widget.direccion ?? "");
    _telefonoController = TextEditingController(text: widget.telefono ?? "");
    _correoController = TextEditingController(text: widget.correo ?? "");
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
    // Validar y guardar los datos de la empresa
  }

  void _cambiarLogo() {
    // Seleccionar/subir un nuevo logo de la empresa
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
            Center(
              child: GestureDetector(
                onTap: _cambiarLogo,
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 46,
                      backgroundColor: AppColors.border,
                      backgroundImage: widget.logoUrl != null
                          ? NetworkImage(widget.logoUrl!)
                          : null,
                      child: widget.logoUrl == null
                          ? const Icon(
                              Icons.storefront_outlined,
                              size: 40,
                              color: AppColors.disabled,
                            )
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.edit,
                          size: 16,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                "Toca para cambiar el logo",
                style: AppTextStyles.subtitle.copyWith(fontSize: 12),
              ),
            ),

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
                      validator: (valor) =>
                          (valor == null || valor.trim().isEmpty)
                          ? "Ingresa la razón social"
                          : null,
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _rtnController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "RTN",
                        prefixIcon: Icon(Icons.badge_outlined),
                      ),
                      validator: (valor) =>
                          (valor == null || valor.trim().isEmpty)
                          ? "Ingresa el RTN"
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
