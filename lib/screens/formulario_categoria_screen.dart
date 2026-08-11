import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../config/app_text_styles.dart';

class FormularioCategoriaScreen extends StatefulWidget {
  const FormularioCategoriaScreen({
    super.key,
    this.nombreCategoria,
    this.descripcion,
    this.activo,
  });

  // null en nombreCategoria -> modo crear. Con datos -> modo editar.
  final String? nombreCategoria;
  final String? descripcion;
  final bool? activo;

  bool get esEdicion => nombreCategoria != null;

  @override
  State<FormularioCategoriaScreen> createState() =>
      _FormularioCategoriaScreenState();
}

class _FormularioCategoriaScreenState extends State<FormularioCategoriaScreen> {
  late final TextEditingController _nombreController;
  late final TextEditingController _descripcionController;
  late bool _activo;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(
      text: widget.nombreCategoria ?? "",
    );
    _descripcionController = TextEditingController(
      text: widget.descripcion ?? "",
    );
    _activo = widget.activo ?? true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          widget.esEdicion ? "Editar categoría" : "Nueva categoría",
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
              onPressed: () {
                // Validar y guardar la categoría (crear o actualizar)
              },
              icon: Icon(widget.esEdicion ? Icons.save_outlined : Icons.add),
              label: Text(
                widget.esEdicion ? "Guardar cambios" : "Crear categoría",
              ),
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
