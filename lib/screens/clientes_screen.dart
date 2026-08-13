import 'package:flutter/material.dart';
import '../config/app_text_styles.dart';
import '../config/app_colors.dart';
import '../models/cliente_model.dart';
import '../widgets/cliente_card.dart';

class ClientesScreen extends StatelessWidget {
  const ClientesScreen({super.key});

  List<Cliente> get _clientes => [
    Cliente(
      idCliente: 1,
      nombreCliente: 'Ana Gómez',
      rtn: '0801-1990-12345',
      direccion: 'Col. Palmira, Tegucigalpa',
      telefono: '9988-7766',
      correo: 'ana.gomez@email.com',
      fechaRegistro: DateTime(2025, 1, 12),
      estado: true,
    ),
    Cliente(
      idCliente: 2,
      nombreCliente: 'Distribuidora El Sol S.A.',
      rtn: '0801-2015-67890',
      direccion: 'Blvd. Morazán, Tegucigalpa',
      telefono: '2234-5566',
      correo: 'contacto@elsol.hn',
      fechaRegistro: DateTime(2025, 6, 3),
      estado: true,
    ),
    Cliente(
      idCliente: 3,
      nombreCliente: 'Roberto Suazo',
      rtn: '0501-1985-54321',
      direccion: 'Barrio Los Andes, Comayagua',
      telefono: '9911-2233',
      correo: 'r.suazo@email.com',
      fechaRegistro: DateTime(2026, 3, 20),
      estado: false,
    ),
    Cliente(
      idCliente: 4,
      nombreCliente: 'Mini Market La Esquina',
      rtn: '0801-2020-11223',
      direccion: 'Col. Kennedy, Tegucigalpa',
      telefono: '2245-9900',
      correo: 'laesquina@market.hn',
      fechaRegistro: DateTime(2026, 7, 15),
      estado: true,
    ),
  ];

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
          content: Text(
            cliente == null
                ? 'Cliente creado correctamente'
                : 'Cliente actualizado correctamente',
          ),
          backgroundColor: AppColors.success,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clientes', style: AppTextStyles.screenTitle),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
      ),
      backgroundColor: AppColors.background,
      body: ListView.builder(
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
              fechaRegistro: _formatearFecha(cliente.fechaRegistro),
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
