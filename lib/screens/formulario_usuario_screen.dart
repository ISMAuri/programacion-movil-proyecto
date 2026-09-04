import 'package:flutter/material.dart';
import 'package:programacion_movil_proyecto/services/auth_service.dart';
import '../config/app_colors.dart';
import '../config/app_text_styles.dart';

class FormularioUsuarioScreen extends StatefulWidget {
  const FormularioUsuarioScreen({super.key});

  @override
  State<FormularioUsuarioScreen> createState() =>
      _FormularioUsuarioScreenState();
}

class _FormularioUsuarioScreenState extends State<FormularioUsuarioScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nombreController = TextEditingController();
  late final TextEditingController _correoController = TextEditingController();
  late final TextEditingController _rolController = TextEditingController();
  // late final TextEditingController _contrasenaController =
  //     TextEditingController();
  // late final TextEditingController _confirmarContrasenaController =
  //     TextEditingController();

  final AuthService _authService = AuthService();

  // bool _cambiarContrasena = false;
  // bool _ocultarContrasena = true;

  bool cargando = true;

  void _cargarUsuarioActual() async {
    try {
      final usuario = await _authService.getCurrentUser();

      if (!mounted) return;

      setState(() {
        _nombreController.text = usuario.fullName;
        _correoController.text = usuario.email;
        _rolController.text = usuario.role;
        cargando = false;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error al cargar usuario"),
          backgroundColor: AppColors.error,
        ),
      );

      setState(() => cargando = false);
    }
  }

  @override
  void initState() {
    super.initState();

    _cargarUsuarioActual();
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _correoController.dispose();
    // _contrasenaController.dispose();
    // _confirmarContrasenaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text("Mi usuario", style: AppTextStyles.screenTitle),
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
                            "Información personal",
                            style: AppTextStyles.sectionTitle,
                          ),
                          const SizedBox(height: 14),
                          TextFormField(
                            readOnly: true,
                            controller: _nombreController,
                            decoration: const InputDecoration(
                              labelText: "Nombre de usuario",
                              prefixIcon: Icon(Icons.person_outline),
                            ),
                            validator: (valor) =>
                                (valor == null || valor.trim().isEmpty)
                                ? "Ingresa tu nombre"
                                : null,
                          ),
                          const SizedBox(height: 14),
                          TextFormField(
                            readOnly: true,
                            controller: _correoController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              labelText: "Correo electrónico",
                              prefixIcon: Icon(Icons.email_outlined),
                            ),
                            validator: (valor) {
                              if (valor == null || valor.trim().isEmpty) {
                                return "Ingresa tu correo";
                              }
                              if (!valor.contains("@"))
                                return "Correo inválido";
                              return null;
                            },
                          ),
                          const SizedBox(height: 14),
                          TextFormField(
                            readOnly: true,
                            controller: _rolController,
                            decoration: const InputDecoration(
                              labelText: "Rol",
                              prefixIcon: Icon(Icons.admin_panel_settings),
                            ),
                            validator: (valor) {
                              if (valor == null || valor.trim().isEmpty) {
                                return "Ingresa el rol";
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Card(
                  //   elevation: 2,
                  //   color: AppColors.white,
                  //   shape: RoundedRectangleBorder(
                  //     borderRadius: BorderRadius.circular(16),
                  //   ),
                  //   child: Padding(
                  //     padding: const EdgeInsets.all(18),
                  //     child: Column(
                  //       crossAxisAlignment: CrossAxisAlignment.start,
                  //       children: [
                  //         SwitchListTile(
                  //           contentPadding: EdgeInsets.zero,
                  //           activeTrackColor: AppColors.primary,
                  //           title: Text(
                  //             "Cambiar contraseña",
                  //             style: AppTextStyles.subtitle,
                  //           ),
                  //           value: _cambiarContrasena,
                  //           onChanged: (valor) =>
                  //               setState(() => _cambiarContrasena = valor),
                  //         ),
                  //         if (_cambiarContrasena) ...[
                  //           const SizedBox(height: 8),
                  //           TextFormField(
                  //             controller: _contrasenaController,
                  //             obscureText: _ocultarContrasena,
                  //             decoration: InputDecoration(
                  //               labelText: "Nueva contraseña",
                  //               prefixIcon: const Icon(Icons.lock_outline),
                  //               suffixIcon: IconButton(
                  //                 icon: Icon(
                  //                   _ocultarContrasena
                  //                       ? Icons.visibility_outlined
                  //                       : Icons.visibility_off_outlined,
                  //                 ),
                  //                 onPressed: () => setState(
                  //                   () => _ocultarContrasena =
                  //                       !_ocultarContrasena,
                  //                 ),
                  //               ),
                  //             ),
                  //             validator: (valor) {
                  //               if (!_cambiarContrasena) return null;
                  //               if (valor == null || valor.length < 6) {
                  //                 return "Mínimo 6 caracteres";
                  //               }
                  //               return null;
                  //             },
                  //           ),
                  //           const SizedBox(height: 14),
                  //           TextFormField(
                  //             controller: _confirmarContrasenaController,
                  //             obscureText: _ocultarContrasena,
                  //             decoration: const InputDecoration(
                  //               labelText: "Confirmar contraseña",
                  //               prefixIcon: Icon(Icons.lock_outline),
                  //             ),
                  //             validator: (valor) {
                  //               if (!_cambiarContrasena) return null;
                  //               if (valor != _contrasenaController.text) {
                  //                 return "Las contraseñas no coinciden";
                  //               }
                  //               return null;
                  //             },
                  //           ),
                  //         ],
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  const SizedBox(height: 16),

                  // Card(
                  //   elevation: 2,
                  //   color: AppColors.white,
                  //   shape: RoundedRectangleBorder(
                  //     borderRadius: BorderRadius.circular(16),
                  //   ),
                  //   child: Padding(
                  //     padding: const EdgeInsets.all(18),
                  //     child: SwitchListTile(
                  //       contentPadding: EdgeInsets.zero,
                  //       activeTrackColor: AppColors.success,
                  //       title: Text(
                  //         "Cuenta activa",
                  //         style: AppTextStyles.subtitle,
                  //       ),
                  //       subtitle: Text(
                  //         _activo
                  //             ? "Puedes iniciar sesión con normalidad"
                  //             : "El acceso quedará deshabilitado",
                  //         style: AppTextStyles.subtitle.copyWith(fontSize: 12),
                  //       ),
                  //       value: _activo,
                  //       onChanged: (valor) => setState(() => _activo = valor),
                  //     ),
                  //   ),
                  // ),
                  const SizedBox(height: 24),

                  // SizedBox(
                  //   width: double.infinity,
                  //   height: 50,
                  //   child: ElevatedButton.icon(
                  //     onPressed: null,
                  //     icon: const Icon(Icons.save_outlined),
                  //     label: const Text("Guardar cambios"),
                  //     style: ElevatedButton.styleFrom(
                  //       backgroundColor: AppColors.primary,
                  //       foregroundColor: AppColors.white,
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(14),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  const SizedBox(height: 15),
                ],
              ),
      ),
    );
  }
}
