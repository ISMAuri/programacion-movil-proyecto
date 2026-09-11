import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../config/app_colors.dart';
import '../config/app_text_styles.dart';
import '../services/auth_service.dart';
import '../services/notification_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final AuthService _authService = AuthService();

  final TextEditingController nombreController = TextEditingController();
  final TextEditingController apellidoController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmarPasswordController =
      TextEditingController();

  bool loading = false;

  Future<void> register() async {
    // Obtener datos
    final nombre = nombreController.text.trim();
    final apellido = apellidoController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;
    final confirmarPassword = confirmarPasswordController.text;

    // Validar campos obligatorios
    if (nombre.isEmpty ||
        apellido.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmarPassword.isEmpty) {
      _mostrarMensaje('Todos los campos son obligatorios', AppColors.error);
      return;
    }

    // Validar correo
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

    if (!emailRegex.hasMatch(email)) {
      _mostrarMensaje('Ingresa un correo electrónico válido', AppColors.error);
      return;
    }

    // Validar contraseña
    if (password.length < 8) {
      _mostrarMensaje(
        'La contraseña debe tener al menos 8 caracteres',
        AppColors.error,
      );
      return;
    }

    // Confirmar contraseña
    if (password != confirmarPassword) {
      _mostrarMensaje('Las contraseñas no coinciden', AppColors.error);
      return;
    }

    try {
      setState(() {
        loading = true;
      });

      // Unir nombre y apellido
      final fullName = '$nombre $apellido';

      final user = await _authService.register(
        fullName: fullName,
        email: email,
        password: password,
        role: 'client',
      );

      if (!mounted) return;

      _mostrarMensaje(
        'Usuario ${user.fullName} registrado correctamente',
        AppColors.success,
      );
      NotificationService.mostrarNotificacion(
        titulo: 'Registro completado. Tu cuenta ha sido creada correctamente.',
        mensaje: 'Se ha creado el usuario ${user.fullName}',
      );

      // Regresar al login después del registro
      Navigator.pop(context);
    } on DioException catch (e) {
      if (!mounted) return;

      if (e.response?.statusCode == 409) {
        _mostrarMensaje(
          'El correo electrónico ya está registrado',
          AppColors.error,
        );
      } else if (e.response?.statusCode == 400) {
        _mostrarMensaje('Los datos enviados no son válidos', AppColors.error);
      } else {
        _mostrarMensaje('No se pudo completar el registro', AppColors.error);
      }
    } catch (e) {
      if (!mounted) return;

      _mostrarMensaje(
        'Ocurrió un error al registrar el usuario $e',
        AppColors.error,
      );
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  void _mostrarMensaje(String mensaje, Color color) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(mensaje), backgroundColor: color));
  }

  @override
  void dispose() {
    nombreController.dispose();
    apellidoController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmarPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: const Text('Crear cuenta'),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),

          child: Card(
            shadowColor: Colors.black26,
            color: AppColors.white,

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),

            child: Padding(
              padding: const EdgeInsets.all(25),

              child: Column(
                children: [
                  Image.asset(
                    'assets/icons/app_icon.png',
                    width: 90,
                    height: 90,
                  ),

                  const SizedBox(height: 15),

                  const Text(
                    'Crear una cuenta',
                    style: AppTextStyles.screenTitle2,
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'Completa tus datos para registrarte',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 15),
                  ),

                  const SizedBox(height: 25),

                  // Nombre
                  TextField(
                    controller: nombreController,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      labelText: 'Nombre',
                      prefixIcon: Icon(
                        Icons.person_outline,
                        color: AppColors.primary,
                      ),
                      filled: true,
                      fillColor: AppColors.background,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Apellido
                  TextField(
                    controller: apellidoController,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      labelText: 'Apellido',
                      prefixIcon: Icon(
                        Icons.person_outline,
                        color: AppColors.primary,
                      ),
                      filled: true,
                      fillColor: AppColors.background,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Correo
                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Correo electrónico',
                      prefixIcon: Icon(
                        Icons.email_outlined,
                        color: AppColors.primary,
                      ),
                      filled: true,
                      fillColor: AppColors.background,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Contraseña
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Contraseña',
                      prefixIcon: Icon(
                        Icons.lock_outline,
                        color: AppColors.primary,
                      ),
                      filled: true,
                      fillColor: AppColors.background,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Confirmar contraseña
                  TextField(
                    controller: confirmarPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Confirmar contraseña',
                      prefixIcon: Icon(
                        Icons.lock_outline,
                        color: AppColors.primary,
                      ),
                      filled: true,
                      fillColor: AppColors.background,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  // Botón registrar
                  SizedBox(
                    width: double.infinity,

                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),

                      onPressed: loading ? null : register,

                      child: loading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'Crear cuenta',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  TextButton(
                    onPressed: loading
                        ? null
                        : () {
                            Navigator.pop(context);
                          },
                    child: const Text('Ya tengo una cuenta'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
