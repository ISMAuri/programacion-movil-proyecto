import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../config/app_text_styles.dart';
import '../models/login_request.dart';
import '../services/auth_service.dart';
import '../services/storage_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool loading = false;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> login() async {
    try {
      setState(() {
        loading = true;
      });

      final request = LoginRequest(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final response = await AuthService().login(request);

      // Persistimos el token para que ApiClient lo adjunto en proximos requests
      await StorageService().saveToken(response.accessToken);

      if (!mounted) return;

      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bienvenido ${response.user.fullName}'), backgroundColor: AppColors.success),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Correo o contraseña incorrectos'), backgroundColor: AppColors.error),
      );
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        alignment: Alignment.center,

        child: Card(
          shadowColor: Colors.black26,
          color: AppColors.white,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),

          child: Padding(
            padding: const EdgeInsets.all(25),

            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icono
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Image.asset(
                    'assets/icons/app_icon.png',
                    width: 120,
                    height: 120,
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  "Inventario Fácil",
                  style: AppTextStyles.screenTitle2,
                ),

                const SizedBox(height: 8),

                Text(
                  "Inicia sesión para continuar",
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 15),
                ),

                const SizedBox(height: 30),

                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: "Correo",
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

                TextField(
                  controller: passwordController,
                  obscureText: true,

                  decoration: InputDecoration(
                    labelText: "Contraseña",

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
                    onPressed: () {
                      loading ? null : login();
                    },
                    child: loading
                        ? const CircularProgressIndicator()
                        : const Text(
                            "Ingresar",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
