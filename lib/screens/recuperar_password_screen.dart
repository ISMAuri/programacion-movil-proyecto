import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../config/app_colors.dart';
import '../config/app_text_styles.dart';
import '../services/auth_service.dart';

class RecuperarPasswordScreen extends StatefulWidget {
  const RecuperarPasswordScreen({super.key});

  @override
  State<RecuperarPasswordScreen> createState() =>
      _RecuperarPasswordScreenState();
}

class _RecuperarPasswordScreenState extends State<RecuperarPasswordScreen> {
  final AuthService _authService = AuthService();

  final _formCorreoKey = GlobalKey<FormState>();
  final _formOtpKey = GlobalKey<FormState>();
  final _formPasswordKey = GlobalKey<FormState>();

  final _correoController = TextEditingController();
  final _otpController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmarPasswordController = TextEditingController();

  int _pasoActual = 0;

  String? _recoveryId;

  bool _cargando = false;

  bool _ocultarPassword = true;
  bool _ocultarConfirmarPassword = true;

  @override
  void dispose() {
    _correoController.dispose();
    _otpController.dispose();
    _passwordController.dispose();
    _confirmarPasswordController.dispose();
    super.dispose();
  }

  String _obtenerMensajeError(Object error, String mensajeDefault) {
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

    return mensajeDefault;
  }

  void _mostrarError(String mensaje) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(mensaje), backgroundColor: AppColors.error),
      );
  }

  void _mostrarExito(String mensaje) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(mensaje), backgroundColor: AppColors.success),
      );
  }

  Future<void> _enviarCodigo() async {
    if (!_formCorreoKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _cargando = true;
    });

    try {
      final recoveryId = await _authService.solicitarOtpPassword(
        email: _correoController.text.trim(),
      );

      if (!mounted) return;

      setState(() {
        _recoveryId = recoveryId;
        _otpController.clear();
        _pasoActual = 1;
        _cargando = false;
      });

      _mostrarExito(
        'Si el correo está registrado, recibirás un código de verificación.',
      );
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _cargando = false;
      });

      _mostrarError(
        _obtenerMensajeError(error, 'No se pudo enviar el código.'),
      );
    }
  }

  Future<void> _reenviarCodigo() async {
    if (_correoController.text.trim().isEmpty) {
      return;
    }

    setState(() {
      _cargando = true;
    });

    try {
      final recoveryId = await _authService.solicitarOtpPassword(
        email: _correoController.text.trim(),
      );

      if (!mounted) return;

      setState(() {
        // El código anterior queda invalidado
        // así que tambien debemos guardar el recoveryId nuevo
        _recoveryId = recoveryId;
        _otpController.clear();
        _cargando = false;
      });

      _mostrarExito('Se envió un nuevo código.');
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _cargando = false;
      });

      _mostrarError(
        _obtenerMensajeError(error, 'No se pudo reenviar el código.'),
      );
    }
  }

  Future<void> _verificarCodigo() async {
    if (!_formOtpKey.currentState!.validate()) {
      return;
    }

    if (_recoveryId == null) {
      _mostrarError('La solicitud de recuperación no es válida.');
      return;
    }

    setState(() {
      _cargando = true;
    });

    try {
      await _authService.verificarOtpPassword(
        recoveryId: _recoveryId!,
        otp: _otpController.text.trim(),
      );

      if (!mounted) return;

      setState(() {
        _pasoActual = 2;
        _cargando = false;
      });

      _mostrarExito('Código verificado correctamente.');
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _cargando = false;
      });

      _mostrarError(
        _obtenerMensajeError(error, 'El código ingresado no es válido.'),
      );
    }
  }

  Future<void> _cambiarPassword() async {
    if (!_formPasswordKey.currentState!.validate()) {
      return;
    }

    if (_recoveryId == null) {
      _mostrarError('La solicitud de recuperación no es válida.');
      return;
    }

    setState(() {
      _cargando = true;
    });

    try {
      await _authService.restablecerPassword(
        recoveryId: _recoveryId!,
        passwordNueva: _passwordController.text,
      );

      if (!mounted) return;

      setState(() {
        _cargando = false;
      });

      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) {
          return AlertDialog(
            icon: const Icon(Icons.check_circle_outline, size: 48),
            title: const Text('Contraseña actualizada'),
            content: const Text(
              'Tu contraseña fue restablecida correctamente. '
              'Ya puedes iniciar sesión con tu nueva contraseña.',
              textAlign: TextAlign.center,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                },
                child: const Text('Aceptar'),
              ),
            ],
          );
        },
      );

      if (!mounted) return;

      Navigator.pop(context);
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _cargando = false;
      });

      _mostrarError(
        _obtenerMensajeError(error, 'No se pudo cambiar la contraseña.'),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Recuperar contraseña', style: AppTextStyles.screenTitle),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _construirIndicador(),

            const SizedBox(height: 24),

            if (_pasoActual == 0) _construirPasoCorreo(),

            if (_pasoActual == 1) _construirPasoOtp(),

            if (_pasoActual == 2) _construirPasoPassword(),
          ],
        ),
      ),
    );
  }

  Widget _construirIndicador() {
    return Row(
      children: [
        _circuloPaso(numero: 1, activo: _pasoActual >= 0),
        _lineaPaso(_pasoActual >= 1),
        _circuloPaso(numero: 2, activo: _pasoActual >= 1),
        _lineaPaso(_pasoActual >= 2),
        _circuloPaso(numero: 3, activo: _pasoActual >= 2),
      ],
    );
  }

  Widget _circuloPaso({required int numero, required bool activo}) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: activo ? AppColors.primary : Colors.grey.shade300,
      ),
      alignment: Alignment.center,
      child: Text(
        '$numero',
        style: TextStyle(
          color: activo ? AppColors.white : Colors.grey.shade700,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _lineaPaso(bool activo) {
    return Expanded(
      child: Container(
        height: 3,
        color: activo ? AppColors.primary : Colors.grey.shade300,
      ),
    );
  }

  Widget _card({required Widget child}) {
    return Card(
      elevation: 2,
      color: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(padding: const EdgeInsets.all(20), child: child),
    );
  }

  Widget _botonPrincipal({
    required String texto,
    required VoidCallback? onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _cargando ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
        ),
        child: _cargando
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Text(texto),
      ),
    );
  }

  Widget _construirPasoCorreo() {
    return Form(
      key: _formCorreoKey,
      child: _card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.lock_reset_outlined, size: 48, color: AppColors.primary),

            const SizedBox(height: 16),

            Text(
              '¿Olvidaste tu contraseña?',
              style: AppTextStyles.sectionTitle,
            ),

            const SizedBox(height: 8),

            const Text(
              'Ingresa el correo electrónico asociado a tu cuenta. '
              'Te enviaremos un código de verificación.',
            ),

            const SizedBox(height: 24),

            TextFormField(
              controller: _correoController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.email],
              decoration: const InputDecoration(
                labelText: 'Correo electrónico',
                prefixIcon: Icon(Icons.email_outlined),
              ),
              validator: (valor) {
                final correo = valor?.trim() ?? '';

                if (correo.isEmpty) {
                  return 'Ingresa tu correo electrónico';
                }

                final correoValido = RegExp(
                  r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                ).hasMatch(correo);

                if (!correoValido) {
                  return 'Ingresa un correo válido';
                }

                return null;
              },
              onFieldSubmitted: (_) {
                if (!_cargando) {
                  _enviarCodigo();
                }
              },
            ),

            const SizedBox(height: 24),

            _botonPrincipal(texto: 'Enviar código', onPressed: _enviarCodigo),
          ],
        ),
      ),
    );
  }

  Widget _construirPasoOtp() {
    return Form(
      key: _formOtpKey,
      child: _card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.mark_email_read_outlined,
              size: 48,
              color: AppColors.primary,
            ),

            const SizedBox(height: 16),

            Text('Verifica tu correo', style: AppTextStyles.sectionTitle),

            const SizedBox(height: 8),

            Text(
              'Ingresa el código de 6 dígitos enviado a '
              '${_correoController.text.trim()}.',
            ),

            const SizedBox(height: 24),

            TextFormField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              maxLength: 6,
              textAlign: TextAlign.center,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(6),
              ],
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                letterSpacing: 10,
              ),
              decoration: const InputDecoration(
                labelText: 'Código',
                counterText: '',
              ),
              validator: (valor) {
                final otp = valor?.trim() ?? '';

                if (otp.length != 6) {
                  return 'Ingresa los 6 dígitos';
                }

                if (!RegExp(r'^\d{6}$').hasMatch(otp)) {
                  return 'El código solo debe contener números';
                }

                return null;
              },
              onFieldSubmitted: (_) {
                if (!_cargando) {
                  _verificarCodigo();
                }
              },
            ),

            const SizedBox(height: 24),

            _botonPrincipal(
              texto: 'Verificar código',
              onPressed: _verificarCodigo,
            ),

            const SizedBox(height: 8),

            Center(
              child: TextButton(
                onPressed: _cargando ? null : _reenviarCodigo,
                child: const Text('Reenviar código'),
              ),
            ),

            Center(
              child: TextButton(
                onPressed: _cargando
                    ? null
                    : () {
                        setState(() {
                          _pasoActual = 0;
                          _otpController.clear();
                        });
                      },
                child: const Text('Cambiar correo'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _construirPasoPassword() {
    return Form(
      key: _formPasswordKey,
      child: _card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.password_outlined, size: 48, color: AppColors.primary),

            const SizedBox(height: 16),

            Text(
              'Crea una nueva contraseña',
              style: AppTextStyles.sectionTitle,
            ),

            const SizedBox(height: 8),

            const Text(
              'Debe tener al menos 8 caracteres '
              'e incluir al menos un número.',
            ),

            const SizedBox(height: 24),

            TextFormField(
              controller: _passwordController,
              obscureText: _ocultarPassword,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: 'Nueva contraseña',
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _ocultarPassword = !_ocultarPassword;
                    });
                  },
                  icon: Icon(
                    _ocultarPassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                ),
              ),
              validator: (valor) {
                final password = valor ?? '';

                if (password.isEmpty) {
                  return 'Ingresa una contraseña';
                }

                if (password.length < 8) {
                  return 'Debe tener al menos 8 caracteres';
                }

                if (!RegExp(r'\d').hasMatch(password)) {
                  return 'Debe incluir al menos un número';
                }

                return null;
              },
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _confirmarPasswordController,
              obscureText: _ocultarConfirmarPassword,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                labelText: 'Confirmar contraseña',
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _ocultarConfirmarPassword = !_ocultarConfirmarPassword;
                    });
                  },
                  icon: Icon(
                    _ocultarConfirmarPassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                ),
              ),
              validator: (valor) {
                if (valor == null || valor.isEmpty) {
                  return 'Confirma tu contraseña';
                }

                if (valor != _passwordController.text) {
                  return 'Las contraseñas no coinciden';
                }

                return null;
              },
              onFieldSubmitted: (_) {
                if (!_cargando) {
                  _cambiarPassword();
                }
              },
            ),

            const SizedBox(height: 24),

            _botonPrincipal(
              texto: 'Cambiar contraseña',
              onPressed: _cambiarPassword,
            ),
          ],
        ),
      ),
    );
  }
}
