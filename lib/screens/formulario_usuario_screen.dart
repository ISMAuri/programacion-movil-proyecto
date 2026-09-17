import 'package:dio/dio.dart';
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
  final _perfilFormKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();

  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _rolController = TextEditingController();

  final TextEditingController _contrasenaController = TextEditingController();
  final TextEditingController _confirmarContrasenaController =
      TextEditingController();

  final AuthService _authService = AuthService();

  bool cargando = true;
  bool guardandoPerfil = false;
  bool guardandoPassword = false;

  bool _editandoPerfil = false;
  bool _cambiarContrasena = false;

  bool _ocultarContrasena = true;
  bool _ocultarConfirmacion = true;

  String _nombreOriginal = '';
  String _correoOriginal = '';

  @override
  void initState() {
    super.initState();
    _cargarUsuarioActual();
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _correoController.dispose();
    _rolController.dispose();
    _contrasenaController.dispose();
    _confirmarContrasenaController.dispose();

    super.dispose();
  }

  Future<void> _cargarUsuarioActual() async {
    try {
      final usuario = await _authService.getCurrentUser();

      if (!mounted) return;

      setState(() {
        _nombreController.text = usuario.fullName;
        _correoController.text = usuario.email;
        _rolController.text = _nombreRol(usuario.role);

        _nombreOriginal = usuario.fullName;
        _correoOriginal = usuario.email;

        cargando = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        cargando = false;
      });

      _mostrarError(
        _obtenerMensajeError(e, 'No se pudo cargar la información del usuario'),
      );
    }
  }

  Future<void> _guardarPerfil() async {
    if (!_perfilFormKey.currentState!.validate()) {
      return;
    }

    if (guardandoPerfil) return;

    setState(() {
      guardandoPerfil = true;
    });

    try {
      final usuario = await _authService.updateProfile(
        fullName: _nombreController.text.trim(),
        email: _correoController.text.trim(),
      );

      if (!mounted) return;

      setState(() {
        _nombreController.text = usuario.fullName;
        _correoController.text = usuario.email;
        _rolController.text = _nombreRol(usuario.role);

        _nombreOriginal = usuario.fullName;
        _correoOriginal = usuario.email;

        _editandoPerfil = false;
        guardandoPerfil = false;
      });

      _mostrarExito('Perfil actualizado correctamente');
    } catch (e) {
      if (!mounted) return;

      setState(() {
        guardandoPerfil = false;
      });

      _mostrarError(_obtenerMensajeError(e, 'No se pudo actualizar el perfil'));
    }
  }

  Future<void> _guardarPassword() async {
    if (!_passwordFormKey.currentState!.validate()) {
      return;
    }

    if (guardandoPassword) return;

    setState(() {
      guardandoPassword = true;
    });

    try {
      await _authService.updatePassword(
        newPassword: _contrasenaController.text,
      );

      if (!mounted) return;

      setState(() {
        guardandoPassword = false;
        _cambiarContrasena = false;

        _contrasenaController.clear();
        _confirmarContrasenaController.clear();
      });

      _mostrarExito('Contraseña actualizada correctamente');
    } catch (e) {
      if (!mounted) return;

      setState(() {
        guardandoPassword = false;
      });

      _mostrarError(
        _obtenerMensajeError(e, 'No se pudo actualizar la contraseña'),
      );
    }
  }

  void _cancelarEdicion() {
    setState(() {
      _nombreController.text = _nombreOriginal;
      _correoController.text = _correoOriginal;
      _editandoPerfil = false;
    });
  }

  String _nombreRol(String role) {
    switch (role) {
      case 'admin':
        return 'Administrador';
      case 'provider':
        return 'Proveedor';
      case 'client':
        return 'Cliente';
      case 'user':
        return 'Empleado';
      default:
        return role;
    }
  }

  String _obtenerMensajeError(Object error, String mensajePorDefecto) {
    if (error is DioException) {
      final data = error.response?.data;

      if (data is Map && data['message'] != null) {
        return data['message'].toString();
      }

      if (data is Map &&
          data['errors'] is List &&
          (data['errors'] as List).isNotEmpty) {
        final primerError = (data['errors'] as List).first;

        if (primerError is Map && primerError['message'] != null) {
          return primerError['message'].toString();
        }
      }
    }

    return mensajePorDefecto;
  }

  void _mostrarExito(String mensaje) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(mensaje), backgroundColor: AppColors.success),
      );
  }

  void _mostrarError(String mensaje) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(mensaje), backgroundColor: AppColors.error),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Mi perfil', style: AppTextStyles.screenTitle),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
      ),
      body: cargando
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _buildInformacionPersonal(),

                const SizedBox(height: 16),

                _buildSeguridad(),

                const SizedBox(height: 20),
              ],
            ),
    );
  }

  Widget _buildInformacionPersonal() {
    return Form(
      key: _perfilFormKey,
      child: Card(
        elevation: 2,
        color: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Información personal',
                      style: AppTextStyles.sectionTitle,
                    ),
                  ),

                  if (!_editandoPerfil)
                    IconButton(
                      tooltip: 'Editar perfil',
                      onPressed: () {
                        setState(() {
                          _editandoPerfil = true;
                        });
                      },
                      icon: const Icon(Icons.edit_outlined),
                    ),
                ],
              ),

              const SizedBox(height: 14),

              TextFormField(
                controller: _nombreController,
                readOnly: !_editandoPerfil,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  labelText: 'Nombre de usuario',
                  prefixIcon: const Icon(Icons.person_outline),
                  filled: !_editandoPerfil,
                  fillColor: !_editandoPerfil ? Colors.grey[200] : null,
                ),
                validator: (valor) {
                  final texto = valor?.trim() ?? '';

                  if (texto.isEmpty) {
                    return 'Ingresa tu nombre';
                  }

                  if (texto.length < 3) {
                    return 'El nombre debe tener al menos 3 caracteres';
                  }

                  if (texto.length > 150) {
                    return 'El nombre no puede superar 150 caracteres';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 14),

              TextFormField(
                controller: _correoController,
                readOnly: !_editandoPerfil,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Correo electrónico',
                  prefixIcon: const Icon(Icons.email_outlined),
                  filled: !_editandoPerfil,
                  fillColor: !_editandoPerfil ? Colors.grey[200] : null,
                ),
                validator: (valor) {
                  final texto = valor?.trim() ?? '';

                  if (texto.isEmpty) {
                    return 'Ingresa tu correo';
                  }

                  final correoValido = RegExp(
                    r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                  ).hasMatch(texto);

                  if (!correoValido) {
                    return 'Ingresa un correo válido';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 14),

              TextFormField(
                controller: _rolController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Rol',
                  prefixIcon: const Icon(Icons.admin_panel_settings_outlined),
                  fillColor: Colors.grey[200],
                  filled: true,
                ),
              ),

              if (_editandoPerfil) ...[
                const SizedBox(height: 20),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: guardandoPerfil ? null : _cancelarEdicion,
                        child: const Text('Cancelar'),
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: guardandoPerfil ? null : _guardarPerfil,
                        icon: guardandoPerfil
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.save_outlined),
                        label: Text(
                          guardandoPerfil ? 'Guardando...' : 'Guardar',
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSeguridad() {
    return Form(
      key: _passwordFormKey,
      child: Card(
        elevation: 2,
        color: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Seguridad', style: AppTextStyles.sectionTitle),

              const SizedBox(height: 6),

              Text(
                'Puedes cambiar la contraseña de tu cuenta.',
                style: AppTextStyles.subtitle.copyWith(fontSize: 12),
              ),

              const SizedBox(height: 10),

              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                activeTrackColor: AppColors.primary,
                title: Text(
                  'Cambiar contraseña',
                  style: AppTextStyles.subtitle,
                ),
                value: _cambiarContrasena,
                onChanged: guardandoPassword
                    ? null
                    : (valor) {
                        setState(() {
                          _cambiarContrasena = valor;

                          if (!valor) {
                            _contrasenaController.clear();
                            _confirmarContrasenaController.clear();
                          }
                        });
                      },
              ),

              if (_cambiarContrasena) ...[
                const SizedBox(height: 8),

                TextFormField(
                  controller: _contrasenaController,
                  obscureText: _ocultarContrasena,
                  decoration: InputDecoration(
                    labelText: 'Nueva contraseña',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _ocultarContrasena = !_ocultarContrasena;
                        });
                      },
                      icon: Icon(
                        _ocultarContrasena
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                    ),
                  ),
                  validator: (valor) {
                    if (!_cambiarContrasena) {
                      return null;
                    }

                    final password = valor ?? '';

                    if (password.isEmpty) {
                      return 'Ingresa la nueva contraseña';
                    }

                    if (password.length < 8) {
                      return 'La contraseña debe tener al menos 8 caracteres';
                    }

                    if (!RegExp(r'\d').hasMatch(password)) {
                      return 'La contraseña debe incluir al menos un número';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 14),

                TextFormField(
                  controller: _confirmarContrasenaController,
                  obscureText: _ocultarConfirmacion,
                  decoration: InputDecoration(
                    labelText: 'Confirmar nueva contraseña',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _ocultarConfirmacion = !_ocultarConfirmacion;
                        });
                      },
                      icon: Icon(
                        _ocultarConfirmacion
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                    ),
                  ),
                  validator: (valor) {
                    if (!_cambiarContrasena) {
                      return null;
                    }

                    if (valor == null || valor.isEmpty) {
                      return 'Confirma la nueva contraseña';
                    }

                    if (valor != _contrasenaController.text) {
                      return 'Las contraseñas no coinciden';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: guardandoPassword ? null : _guardarPassword,
                    icon: guardandoPassword
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.lock_reset_outlined),
                    label: Text(
                      guardandoPassword
                          ? 'Actualizando...'
                          : 'Cambiar contraseña',
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
              ],
            ],
          ),
        ),
      ),
    );
  }
}
