import 'package:flutter/material.dart';
import 'package:programacion_movil_proyecto/services/empresa_service.dart';
import '../config/app_colors.dart';
import '../config/app_text_styles.dart';
import '../models/empresa.dart';

class FormularioEmpresaScreen extends StatefulWidget {
  const FormularioEmpresaScreen({super.key});

  // Pantalla siempre en modo edición

  @override
  State<FormularioEmpresaScreen> createState() =>
      _FormularioEmpresaScreenState();
}

class _FormularioEmpresaScreenState extends State<FormularioEmpresaScreen> {
  final _formKey = GlobalKey<FormState>();

  // solo debe haber una empresa en el sistema
  final _idEmpresa = 1;
  final EmpresaService _empresaService = EmpresaService();
  bool cargando = true;
  late final TextEditingController _nombreController = TextEditingController();
  late final TextEditingController _razonSocialController =
      TextEditingController();
  late final TextEditingController _rtnController = TextEditingController();
  late final TextEditingController _direccionController =
      TextEditingController();
  late final TextEditingController _telefonoController =
      TextEditingController();
  late final TextEditingController _correoController = TextEditingController();

  Future<void> _cargarEmpresa() async {
    try {
      final empresa = await _empresaService.getEmpresa(_idEmpresa);

      if (!mounted) return;

      setState(() {
        _nombreController.text = empresa.nombreEmpresa;
        _razonSocialController.text = empresa.razonSocial ?? '';
        _rtnController.text = empresa.rtn ?? '';
        _direccionController.text = empresa.direccion ?? '';
        _telefonoController.text = empresa.telefono ?? '';
        _correoController.text = empresa.correo ?? '';

        cargando = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        cargando = false;
      });
    }
  }

  Future<void> _guardarEmpresa() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final empresa = Empresa(
      idEmpresa: _idEmpresa,
      nombreEmpresa: _nombreController.text.trim(),
      razonSocial: _razonSocialController.text.trim(),
      rtn: _rtnController.text.trim(),
      direccion: _direccionController.text.trim(),
      telefono: _telefonoController.text.trim(),
      correo: _correoController.text.trim(),
    );

    try {
      await _empresaService.putEmpresa(_idEmpresa, empresa);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Datos de la empresa actualizados correctamente'),
          backgroundColor: AppColors.success,
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar datos de la empresa: $e'),
          backgroundColor: AppColors.error,),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _cargarEmpresa();
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
        child: cargando
            ? const Center(child: CircularProgressIndicator())
            : ListView(
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
                              if (valor == null || valor.trim().isEmpty) {
                                return null;
                              }
                              if (!valor.contains("@")) {
                                return "Correo inválido";
                              }
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
                      onPressed: _guardarEmpresa,
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
