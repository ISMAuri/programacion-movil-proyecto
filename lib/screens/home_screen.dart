import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../config/app_text_styles.dart';
import 'categorias_screen.dart';
import 'clientes_screen.dart';
import 'dashboard_screen.dart';
import 'login_screen.dart';
import 'movimientos_screen.dart';
import 'settings_screen.dart';
import 'ventas_screen.dart';
import 'listado_productos_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final List<Widget> _screens = [
    const DashboardScreen(),
    const SettingsScreen(),
  ];

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
      drawer: Menu(),
      backgroundColor: AppColors.background,

      // contenido de la pantalla de inicio
      body: _screens[_selectedIndex],

      // ----------------------------
      // barra de navegacion inferior
      // ----------------------------
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ListadoProductosScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.category),
            title: const Text('Categorías'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CategoriasScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.shopping_cart),
            title: const Text('Ventas'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const VentasScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text('Clientes'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ClientesScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.list),
            title: const Text('Movimientos'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MovimientosScreen()),
              );
            },
          ),
          // ListTile(
          //   leading: const Icon(Icons.settings),
          //   title: const Text('Configuración'),
          //   onTap: () {
          //     null;
          //   },
          // ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Cerrar sesión'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
