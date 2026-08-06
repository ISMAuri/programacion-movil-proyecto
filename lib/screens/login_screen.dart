import 'package:flutter/material.dart';
import 'home_screen.dart';
import '../config/app_colors.dart';
import '../config/app_text_styles.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          alignment: Alignment.center,

          child: Card(
            elevation: 8,
            shadowColor: Colors.black26,
            color: AppColors.white,

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),

            child: Padding(
              padding: const EdgeInsets.all(28),

              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo / Icono
                  Container(
                    width: 75,
                    height: 75,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),

                    child: Icon(
                      Icons.inventory_2_outlined,
                      size: 40,
                      color: AppColors.primary,
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "Inventario Fácil",
                    style: AppTextStyles.screenTitle,
                  ),

                  const SizedBox(height: 8),

                  Text(
                    "Inicia sesión para continuar",
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 15),
                  ),

                  const SizedBox(height: 30),

                  TextField(
                    decoration: InputDecoration(
                      labelText: "Usuario",
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
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomeScreen(),
                          ),
                        );
                      },

                      child: const Text(
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
