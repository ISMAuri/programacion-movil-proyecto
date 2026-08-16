import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../config/app_text_styles.dart';
import 'dashboard_screen.dart';
import 'listado_productos_screen.dart';
import 'configuracion_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _secciones = const [
    DashboardScreen(),
    ListadoProductosScreen(),
    ConfiguracionScreen(),
  ];

  void _cambiarSeccion(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Inventario Fácil", style: AppTextStyles.screenTitle),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      drawer: Menu(
        onSeleccionarSeccion: (index) {
          Navigator.pop(context);
          _cambiarSeccion(index);
        },
      ),

      backgroundColor: AppColors.background,

      body: IndexedStack(index: _selectedIndex, children: _secciones),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _cambiarSeccion,
        backgroundColor: AppColors.white,

        // Diferencia visual entre sección activa e inactivas.
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.disabled,

        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Productos'),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Configuración',
          ),
        ],
      ),
      floatingActionButton: _selectedIndex == 1
          ? FloatingActionButton(
              onPressed: () =>
                  Navigator.pushNamed(context, "/formulario_producto"),
              backgroundColor: AppColors.secondary,
              foregroundColor: AppColors.white,
              shape: const CircleBorder(),
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}

class Menu extends StatelessWidget {
  final ValueChanged<int> onSeleccionarSeccion;

  const Menu({super.key, required this.onSeleccionarSeccion});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 260,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            padding: EdgeInsets.zero,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary, AppColors.secondary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      'assets/icons/app_icon.png',
                      width: 40,
                      height: 40,
                    ),
                  ),
                  // Icon(Icons.inventory_2, color: AppColors.white, size: 40),
                  SizedBox(height: 10),
                  Text("Inversiones Sammy", style: AppTextStyles.screenTitle),
                  SizedBox(height: 4),
                  Text("Gestión de Inventario", style: AppTextStyles.subtitle2),
                ],
              ),
            ),
          ),

          // Productos forma parte del BottomNavigationBar.
          ListTile(
            leading: const Icon(Icons.inventory),
            title: const Text('Listado de Productos'),
            onTap: () => onSeleccionarSeccion(1),
          ),
          ListTile(
            leading: const Icon(Icons.category),
            title: const Text('Categorías'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, "/categorias");
            },
          ),
          ListTile(
            leading: const Icon(Icons.shopping_cart),
            title: const Text('Ventas'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, "/ventas");
            },
          ),
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text('Clientes'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, "/clientes");
            },
          ),
          ListTile(
            leading: const Icon(Icons.list),
            title: const Text('Movimientos'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, "/movimientos");
            },
          ),

          ExpansionTile(
            leading: const Icon(Icons.settings),
            title: const Text('Configuración'),
            children: [
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Usuario'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/formulario_usuario');
                },
              ),
              ListTile(
                leading: const Icon(Icons.business),
                title: const Text('Empresa'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/formulario_empresa');
                },
              ),
              ListTile(
                leading: const Icon(Icons.receipt_long),
                title: const Text('Datos fiscales'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/formulario_datos_fiscales');
                },
              ),
            ],
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: AppColors.error),
            title: const Text(
              'Cerrar sesión',
              style: TextStyle(color: AppColors.error),
            ),
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                "/login",
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}
