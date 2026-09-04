import 'package:flutter/material.dart';
import '../config/app_text_styles.dart';
import '../config/app_colors.dart';
import '../models/cliente.dart';
import '../widgets/cliente_card.dart';
import '../services/cliente_service.dart';

class ClientesScreen extends StatefulWidget {
  const ClientesScreen({super.key});

  @override
  State<ClientesScreen> createState() => _ClientesScreenState();
}

class _ClientesScreenState extends State<ClientesScreen> {
  final ClienteService _clienteService = ClienteService();
  bool cargando = true;
  List<Cliente> _clientes = [];

  Future<void> _cargarClientes() async {
    setState(() => cargando = true);
    try {
      final response = await _clienteService.getClientes(soloActivos: false);

      if (!mounted) return;
      setState(() {
        _clientes = response;
        cargando = false;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error al cargar clientes: $e")));

      setState(() => cargando = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _cargarClientes();
  }

  String _formatearFecha(DateTime fecha) {
    final dia = fecha.day.toString().padLeft(2, '0');
    final mes = fecha.month.toString().padLeft(2, '0');
    return '$dia/$mes/${fecha.year}';
  }

  Future<void> _abrirFormulario(
    BuildContext context, {
    Cliente? cliente,
  }) async {
    final guardado = await Navigator.pushNamed(
      context,
      '/formulario_cliente',
      arguments: cliente,
    );

    if (!context.mounted || guardado != true) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: AppColors.success,
          duration: const Duration(seconds: 5),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: Text(
            cliente == null
                ? 'Cliente creado correctamente.'
                : 'Cliente actualizado correctamente.',
          ),
        ),
      );
    _cargarClientes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clientes', style: AppTextStyles.screenTitle),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        actions: [
          IconButton(
            onPressed: _cargarClientes,
            icon: const Icon(Icons.refresh),
            tooltip: 'Actualizar clientes',
          ),
        ],
      ),
      backgroundColor: AppColors.background,
      body: cargando
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 10),
              itemCount: _clientes.length,
              itemBuilder: (context, index) {
                final cliente = _clientes[index];

                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => _abrirFormulario(context, cliente: cliente),
                  child: ClienteCard(
                    nombreCliente: cliente.nombreCliente,
                    rtn: cliente.rtn ?? 'N/A',
                    direccion: cliente.direccion ?? 'N/A',
                    telefono: cliente.telefono ?? 'N/A',
                    correo: cliente.correo ?? 'N/A',
                    fechaRegistro: cliente.fechaRegistro != null
                        ? _formatearFecha(cliente.fechaRegistro!)
                        : 'N/A',
                    estado: cliente.estado,
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _abrirFormulario(context),
        backgroundColor: AppColors.secondary,
        foregroundColor: AppColors.white,
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
