import 'package:flutter/material.dart';
import '../config/app_text_styles.dart';
import '../config/app_colors.dart';
import '../widgets/movimiento_card.dart';
import '../models/movimiento_inventario.dart';
import '../services/movimiento_inventario_service.dart';
import '../services/auth_service.dart';
import '../models/producto.dart';
import '../models/user.dart';
import '../services/producto_service.dart';

class MovimientosScreen extends StatefulWidget {
  const MovimientosScreen({super.key});

  @override
  State<MovimientosScreen> createState() => _MovimientosScreenState();
}

class _MovimientosScreenState extends State<MovimientosScreen> {
  final MovimientoInventarioService _movimientoInventarioService =
      MovimientoInventarioService();
  final ProductoService _productoService = ProductoService();
  final AuthService _authService = AuthService();
  List<MovimientoInventario> movimientos = [];
  Map<int, Producto> productos = {};
  Map<int, User> usuarios = {};
  bool cargando = true;

  Future<void> _cargarMovimientos() async {
    setState(() => cargando = true);
    try {
      final response = await _movimientoInventarioService.getMovimientos();

      for (final movimiento in response) {
        // obtener producto respectivo al movimiento
        if (!productos.containsKey(movimiento.idProducto)) {
          final producto = await _productoService.getProducto(
            movimiento.idProducto,
          );

          productos[movimiento.idProducto] = producto;
        }

        // obtener usuario respectivo al movimiento
        if (!usuarios.containsKey(movimiento.idUsuario)) {
          final usuario = await _authService.getUser(movimiento.idUsuario);

          usuarios[movimiento.idUsuario] = usuario;
        }
      }

      if (!mounted) return;
      setState(() {
        movimientos = response;
        cargando = false;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al cargar los movimientos $e")),
      );
      setState(() => cargando = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _cargarMovimientos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Movimientos", style: AppTextStyles.screenTitle),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        actions: [
          IconButton(
            onPressed: _cargarMovimientos,
            icon: const Icon(Icons.refresh),
            tooltip: 'Actualizar movimientos',
          ),
        ],
      ),
      backgroundColor: AppColors.background,
      body: cargando
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 10),
              itemCount: movimientos.length,
              itemBuilder: (context, index) {
                final movimiento = movimientos[index];

                final producto = productos[movimiento.idProducto];
                final user = usuarios[movimiento.idUsuario];

                return MovimientoCard(
                  tipoMovimiento: movimiento.tipoMovimiento.name,

                  cantidad: movimiento.cantidad,

                  fechaMovimiento:
                      movimiento.fechaMovimiento?.toString() ?? 'Sin fecha',

                  motivo: movimiento.motivo ?? 'Sin motivo',

                  producto:
                      producto?.nombreProducto ??
                      'Producto ${movimiento.idProducto}',

                  encargado:
                      user?.fullName ?? 'Usuario ${movimiento.idUsuario}',
                );
              },
            ),
    );
  }
}
