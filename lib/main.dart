import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/categorias_screen.dart';
import 'screens/listado_productos_screen.dart';
import 'screens/clientes_screen.dart';
import 'screens/movimientos_screen.dart';
import 'screens/ventas_screen.dart';
import 'screens/configuracion_screen.dart';
import 'screens/formulario_categoria_screen.dart';
import 'screens/formulario_producto_screen.dart';
import 'screens/formulario_cliente_screen.dart';
import 'screens/formulario_venta_screen.dart';
import 'screens/formulario_empresa_screen.dart';
import 'screens/formulario_usuario_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Inventario Fácil',

      initialRoute: '/splash',

      routes: {
        '/splash': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/categorias': (context) => const CategoriasScreen(),
        '/listado_productos': (context) => const ListadoProductosScreen(),
        '/clientes': (context) => const ClientesScreen(),
        '/movimientos': (context) => const MovimientosScreen(),
        '/ventas': (context) => const VentasScreen(),
        '/configuracion': (context) => const ConfiguracionScreen(),
        '/formulario_categoria': (context) => const FormularioCategoriaScreen(),
        '/formulario_producto': (context) => const FormularioProductoScreen(),
        '/formulario_cliente': (context) => const FormularioClienteScreen(),
        '/formulario_venta': (context) => const FormularioVentaScreen(),
        '/formulario_empresa': (context) => const FormularioEmpresaScreen(),
        '/formulario_usuario': (context) => const FormularioUsuarioScreen(),

      },
    );
  }
}
