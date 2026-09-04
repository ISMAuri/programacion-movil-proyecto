import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../config/app_text_styles.dart';
import '../models/categoria.dart';
import '../services/categoria_service.dart';

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
  bool _activo = true;
  bool _argumentosCargados = false;

  bool get _esEdicion => _categoria != null;

  Future<void> _guardarCategoria() async {
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

    final mensaje =
        "Categoría ${_esEdicion ? "actualizada" : "creada"} correctamente";

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(mensaje), backgroundColor: AppColors.success),
      );

    Navigator.pop(
      context,
      true,
    ); //Quita la pantalla y devuelve true para indicar que se guardó correctamente.
  }

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController();
    _descripcionController = TextEditingController();
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
                      labelText: "Nombre de la categoría",
                      prefixIcon: Icon(Icons.category_outlined),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _descripcionController,
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
                    activeTrackColor: AppColors.success,
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
                    onChanged: (valor) => setState(() => _activo = valor),
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
              onPressed: _guardarCategoria,
              icon: Icon(_esEdicion ? Icons.save_outlined : Icons.add),
              label: Text(_esEdicion ? "Guardar cambios" : "Crear categoría"),
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
    _descripcionController.dispose();
    super.dispose();
  }
}
