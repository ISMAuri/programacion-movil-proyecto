import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../config/app_text_styles.dart';

class HomeScreen extends StatelessWidget {
  final Widget child;
  final int selectedIndex;

  const HomeScreen({
    super.key,
    required this.child,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ----------------------------
      // barra de navegacion superior
      // ----------------------------
      appBar: AppBar(
        title: const Text("Inventario Fácil", style: AppTextStyles.screenTitle),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(
          color: Colors.white, // color del icono del drawer
        ),
      ),
      drawer: const Menu(),
      backgroundColor: AppColors.background,

      // contenido de la pantalla de inicio
      body: child,

      // ----------------------------
      // barra de navegacion inferior
      // ----------------------------
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) {
          if (index == selectedIndex) return;

          if (index == 0) {
            Navigator.pushReplacementNamed(context, "/home");
          } else {
            Navigator.pushReplacementNamed(context, "/configuracion");
          }
        },

        backgroundColor: AppColors.white,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Configuración',
          ),
        ],
      ),
    );
  }
}

class Menu extends StatelessWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 260,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: AppColors.primary),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Inversiones Sammy", style: AppTextStyles.screenTitle),
                SizedBox(height: 8),
                Text("Gestión de Inventario", style: AppTextStyles.subtitle2),
              ],
            ),
          ),

          ListTile(
            leading: const Icon(Icons.inventory),
            title: const Text('Productos'),
            onTap: () {
              Navigator.pushNamed(context, "/listado_productos");
            },
          ),
          ListTile(
            leading: const Icon(Icons.category),
            title: const Text('Categorías'),
            onTap: () {
              Navigator.pushNamed(context, "/categorias");
            },
          ),
          ListTile(
            leading: const Icon(Icons.shopping_cart),
            title: const Text('Ventas'),
            onTap: () {
              Navigator.pushNamed(context, "/ventas");
            },
          ),
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text('Clientes'),
            onTap: () {
              Navigator.pushNamed(context, "/clientes");
            },
          ),
          ListTile(
            leading: const Icon(Icons.list),
            title: const Text('Movimientos'),
            onTap: () {
              Navigator.pushNamed(context, "/movimientos");
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: AppColors.error),
            title: const Text('Cerrar sesión', style: TextStyle(color: AppColors.error)),
            onTap: () {
              Navigator.pushReplacementNamed(context, "/login");
            },
          ),
        ],
      ),
    );
  }
}
