import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../config/app_text_styles.dart';
import '../models/cliente.dart';
import '../services/cliente_service.dart';

class FormularioClienteScreen extends StatefulWidget {
  const FormularioClienteScreen({super.key});

  @override
  State<FormularioClienteScreen> createState() =>
      _FormularioClienteScreenState();
}

class _FormularioClienteScreenState extends State<FormularioClienteScreen> {
  final ClienteService _clienteService = ClienteService();
  final _nombreController = TextEditingController();
  final _rtnController = TextEditingController();
  final _direccionController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _correoController = TextEditingController();

  Cliente? _cliente;
  bool _estado = true;
  bool _argumentosCargados = false;

  bool get _esEdicion => _cliente != null;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_argumentosCargados) return;
    _argumentosCargados = true;

    _cliente = ModalRoute.of(context)?.settings.arguments as Cliente?;

    if (_cliente != null) {
      _nombreController.text = _cliente!.nombreCliente;
      _rtnController.text = _cliente!.rtn ?? '';
      _direccionController.text = _cliente!.direccion ?? '';
      _telefonoController.text = _cliente!.telefono ?? '';
      _correoController.text = _cliente!.correo ?? '';
      _estado = _cliente!.estado;
    }
  }

  Future<void> _guardarCliente() async {
    final nombre = _nombreController.text.trim();
    final rtn = _rtnController.text.trim();
    final direccion = _direccionController.text.trim();
    final telefono = _telefonoController.text.trim();
    final correo = _correoController.text.trim();

    if (nombre.isEmpty) {
      _mostrarError('Ingresa el nombre del cliente');
      return;
    }

    if (correo.isNotEmpty && (!correo.contains('@') || !correo.contains('.'))) {
      _mostrarError('Ingresa un correo electrónico válido');
      return;
    }

    final cliente = Cliente(
      idCliente: _cliente?.idCliente,
      nombreCliente: nombre,
      rtn: rtn.isEmpty ? null : rtn,
      direccion: direccion.isEmpty ? null : direccion,
      telefono: telefono.isEmpty ? null : telefono,
      correo: correo.isEmpty ? null : correo,
      estado: _estado,
      fechaRegistro: _cliente?.fechaRegistro ?? DateTime.now()
    );

    try {
      if (_esEdicion) {
        await _clienteService.putCliente(_cliente!.idCliente!, cliente);
      } else {
        await _clienteService.postCliente(cliente);
      }

      if (!mounted) return;

      final mensaje = _esEdicion
          ? 'Cliente actualizado correctamente'
          : 'Cliente creado correctamente';

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text(mensaje), backgroundColor: AppColors.success),
        );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      _mostrarError(
        'Error al ${_esEdicion ? "actualizar" : "crear"} cliente',
      );
    }
  }

  void _mostrarError(String mensaje) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(mensaje), backgroundColor: AppColors.error),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          _esEdicion ? 'Editar cliente' : 'Nuevo cliente',
          style: AppTextStyles.screenTitle,
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            elevation: 2,
            color: AppColors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                children: [
                  TextFormField(
                    controller: _nombreController,
                    decoration: const InputDecoration(
                      labelText: 'Nombre del cliente',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _rtnController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'RTN',
                      prefixIcon: Icon(Icons.badge_outlined),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _direccionController,
                    decoration: const InputDecoration(
                      labelText: 'Dirección',
                      prefixIcon: Icon(Icons.location_on_outlined),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _telefonoController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Teléfono',
                      prefixIcon: Icon(Icons.phone_outlined),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _correoController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Correo',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                  ),
                  const SizedBox(height: 14),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Estado del cliente'),
                    subtitle: Text(_estado ? 'Activo' : 'Inactivo'),
                    value: _estado,
                    activeColor: AppColors.primary,
                    onChanged: (value) {
                      setState(() => _estado = value);
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: _guardarCliente,
              icon: Icon(_esEdicion ? Icons.save_outlined : Icons.add),
              label: Text(_esEdicion ? 'Guardar cambios' : 'Crear cliente'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
          const SizedBox(height: 15),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _rtnController.dispose();
    _direccionController.dispose();
    _telefonoController.dispose();
    _correoController.dispose();
    super.dispose();
  }
}
