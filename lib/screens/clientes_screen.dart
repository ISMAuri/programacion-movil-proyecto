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

  String _busqueda = '';

  @override
  void initState() {
    super.initState();
    _cargarClientes();
  }

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

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: const Text('Error al cargar clientes'),
            backgroundColor: AppColors.error,
          ),
        );

      setState(() => cargando = false);
    }
  }

  List<Cliente> get _clientesFiltrados {
    final texto = _busqueda.toLowerCase().trim();

    if (texto.isEmpty) {
      return _clientes;
    }

    return _clientes.where((cliente) {
      return cliente.nombreCliente.toLowerCase().contains(texto) ||
          (cliente.rtn?.toLowerCase().contains(texto) ?? false) ||
          (cliente.telefono?.toLowerCase().contains(texto) ?? false) ||
          (cliente.correo?.toLowerCase().contains(texto) ?? false);
    }).toList();
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
    final clientes = _clientesFiltrados;

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
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  child: Container(
                    height: 46,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: TextField(
                      onChanged: (valor) {
                        setState(() {
                          _busqueda = valor;
                        });
                      },
                      decoration: const InputDecoration(
                        hintText:
                            'Buscar por nombre, RTN, correo o tel...',
                        prefixIcon: Icon(Icons.search),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: clientes.isEmpty
                      ? const Center(child: Text('No se encontraron clientes'))
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          itemCount: clientes.length,
                          itemBuilder: (context, index) {
                            final cliente = clientes[index];

                            return GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () =>
                                  _abrirFormulario(context, cliente: cliente),
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
                ),
              ],
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
