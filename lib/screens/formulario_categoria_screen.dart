import 'package:flutter/material.dart';

import '../config/app_colors.dart';
import '../config/app_text_styles.dart';
import '../models/categoria.dart';
import '../services/auth_service.dart';
import '../services/categoria_service.dart';
import '../widgets/aviso_card.dart';

class FormularioCategoriaScreen extends StatefulWidget {
  const FormularioCategoriaScreen({super.key});

  @override
  State<FormularioCategoriaScreen> createState() =>
      _FormularioCategoriaScreenState();
}

class _FormularioCategoriaScreenState extends State<FormularioCategoriaScreen> {
  late final TextEditingController _nombreController;
  late final TextEditingController _descripcionController;

  Categoria? _categoria;

  final CategoriaService _categoriaService = CategoriaService();
  final AuthService _authService = AuthService();

  bool _activo = true;
  bool _argumentosCargados = false;

  bool esAdmin = false;

  bool get _esEdicion => _categoria != null;

  @override
  void initState() {
    super.initState();

    _nombreController = TextEditingController();
    _descripcionController = TextEditingController();

    _cargarUsuario();
  }

  Future<void> _cargarUsuario() async {
    try {
      final usuario = await _authService.getCurrentUser();

      if (!mounted) return;

      setState(() {
        esAdmin = usuario.role.trim().toLowerCase() == 'admin';
      });
    } catch (e) {
      debugPrint('Error al cargar rol del usuario: $e');
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_argumentosCargados) return;

    _argumentosCargados = true;

    _categoria = ModalRoute.of(context)?.settings.arguments as Categoria?;

    if (_categoria != null) {
      _nombreController.text = _categoria!.nombre;

      _descripcionController.text = _categoria!.descripcion ?? '';

      _activo = _categoria!.activo;
    }
  }

  Future<void> _guardarCategoria() async {
    // Segunda protección dentro del método.
    if (!esAdmin) {
      return;
    }

    final nombre = _nombreController.text.trim();

    final descripcion = _descripcionController.text.trim();

    if (nombre.isEmpty || descripcion.isEmpty) {
      final mensaje = nombre.isEmpty && descripcion.isEmpty
          ? "Completa el nombre y la descripción"
          : nombre.isEmpty
          ? "Completa el nombre de la categoría"
          : "Completa la descripción de la categoría";

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text(mensaje), backgroundColor: AppColors.error),
        );

      return;
    }

    if (nombre.length < 3) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text("El nombre debe tener al menos 3 caracteres"),
            backgroundColor: AppColors.error,
          ),
        );

      return;
    }

    if (descripcion.length < 5) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text("La descripción debe tener al menos 5 caracteres"),
            backgroundColor: AppColors.error,
          ),
        );

      return;
    }

    try {
      if (_esEdicion) {
        final categoriaActualizada = Categoria(
          id: _categoria!.id,
          nombre: nombre,
          descripcion: descripcion,
          icono: _categoria!.icono,
          activo: _activo,
        );

        await _categoriaService.putCategoria(
          _categoria!.id!,
          categoriaActualizada,
        );
      } else {
        final nuevaCategoria = Categoria(
          nombre: nombre,
          descripcion: descripcion,
          icono: null,
          activo: _activo,
        );

        await _categoriaService.postCategoria(nuevaCategoria);
      }

      if (!mounted) return;

      final mensaje =
          "Categoría ${_esEdicion ? "actualizada" : "creada"} correctamente";

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text(mensaje), backgroundColor: AppColors.success),
        );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error al ${_esEdicion ? "actualizar" : "crear"} categoría',
          ),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: Text(
          _esEdicion ? "Editar categoría" : "Nueva categoría",
          style: AppTextStyles.screenTitle,
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Aviso solamente para empleados.
          if (!esAdmin) ...[
            const AvisoCard(
              text:
                  'Modo de solo lectura. Solo los administradores pueden modificar las categorías.',
            ),
            const SizedBox(height: 16),
          ],

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

                    // Solo admin puede editar.
                    enabled: esAdmin,

                    decoration: const InputDecoration(
                      labelText: "Nombre de la categoría",
                      prefixIcon: Icon(Icons.category_outlined),
                    ),
                  ),

                  const SizedBox(height: 14),

                  TextFormField(
                    controller: _descripcionController,

                    // Solo admin puede editar.
                    enabled: esAdmin,

                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: "Descripción",
                      alignLabelWithHint: true,
                      prefixIcon: Icon(Icons.notes_outlined),
                    ),
                  ),

                  const SizedBox(height: 8),

                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,

                    // Gris para empleados.
                    activeTrackColor: esAdmin
                        ? AppColors.success
                        : AppColors.disabled,

                    title: Text(
                      "Categoría activa",
                      style: AppTextStyles.subtitle,
                    ),

                    subtitle: Text(
                      _activo
                          ? "Visible al crear/editar productos"
                          : "No aparecerá como opción disponible",
                      style: AppTextStyles.subtitle.copyWith(fontSize: 12),
                    ),

                    value: _activo,

                    // Solo admin puede cambiar estado.
                    onChanged: esAdmin
                        ? (valor) {
                            setState(() {
                              _activo = valor;
                            });
                          }
                        : null,
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
              // Empleado = botón bloqueado.
              onPressed: esAdmin ? _guardarCategoria : null,

              icon: Icon(_esEdicion ? Icons.save_outlined : Icons.add),

              label: Text(_esEdicion ? "Guardar cambios" : "Crear categoría"),

              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,

                disabledBackgroundColor: AppColors.disabled,

                foregroundColor: AppColors.white,

                disabledForegroundColor: AppColors.white,

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
    _descripcionController.dispose();

    super.dispose();
  }
}
