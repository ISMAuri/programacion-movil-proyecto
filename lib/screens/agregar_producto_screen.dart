import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../config/app_text_styles.dart';
import '../models/producto_model.dart';

/// Pantalla de formulario para agregar un producto nuevo o editar uno existente.

class AgregarProductoScreen extends StatefulWidget {
  const AgregarProductoScreen({super.key, this.producto});

  final Producto? producto;

  @override
  State<AgregarProductoScreen> createState() => _AgregarProductoScreenState();
}

class _AgregarProductoScreenState extends State<AgregarProductoScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nombreController;
  late final TextEditingController _descripcionController;
  late final TextEditingController _codigoController;
  late final TextEditingController _precioCompraController;
  late final TextEditingController _precioVentaController;
  late final TextEditingController _stockController;
  late final TextEditingController _unidadMedidaController;

  bool _estadoActivo = true;

  bool get _esEdicion => widget.producto != null;

  @override
  void initState() {
    super.initState();
    final p = widget.producto;

    // Si viene un producto (modo edición), se precargan sus valores.
    // Si no, todos los controllers arrancan vacíos (modo agregar).
    _nombreController = TextEditingController(text: p?.nombreProducto ?? '');
    _descripcionController = TextEditingController(text: p?.descripcion ?? '');
    _codigoController = TextEditingController(text: p?.codigoProducto ?? '');
    _precioCompraController = TextEditingController(
      text: p?.precioCompra?.toString() ?? '',
    );
    _precioVentaController = TextEditingController(
      text: p?.precioVenta.toString() ?? '',
    );
    _stockController = TextEditingController(
      text: p?.stockActual.toString() ?? '',
    );
    _unidadMedidaController = TextEditingController(
      text: p?.unidadMedida ?? '',
    );
    _estadoActivo = p?.estado ?? true;
  }

  @override
  void dispose() {
    // Siempre hay que liberar los controllers para no dejar fugas de memoria
    _nombreController.dispose();
    _descripcionController.dispose();
    _codigoController.dispose();
    _precioCompraController.dispose();
    _precioVentaController.dispose();
    _stockController.dispose();
    _unidadMedidaController.dispose();
    super.dispose();
  }

  void _guardarProducto() {
    // Si algún validator de abajo falla, se detiene aquí y se muestran
    // los mensajes de error en rojo debajo de cada campo.
    if (!_formKey.currentState!.validate()) return;

    final producto = Producto(
      // TODO: cuando haya backend, el id lo debería asignar la base de datos.
      idProducto: widget.producto?.idProducto ?? 0,
      // TODO: falta un selector real de categoría (dropdown conectado a
      // CategoriasScreen/categoria_model). Se deja en 1 como valor temporal
      // para que el formulario ya sea funcional mientras tanto.
      idCategoria: widget.producto?.idCategoria ?? 1,
      nombreProducto: _nombreController.text.trim(),
      descripcion: _descripcionController.text.trim().isEmpty
          ? null
          : _descripcionController.text.trim(),
      codigoProducto: _codigoController.text.trim().isEmpty
          ? null
          : _codigoController.text.trim(),
      precioCompra: _precioCompraController.text.trim().isEmpty
          ? null
          : double.parse(_precioCompraController.text.trim()),
      precioVenta: double.parse(_precioVentaController.text.trim()),
      stockActual: int.parse(_stockController.text.trim()),
      unidadMedida: _unidadMedidaController.text.trim().isEmpty
          ? null
          : _unidadMedidaController.text.trim(),
      estado: _estadoActivo,
    );

    Navigator.pop(context, producto);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _esEdicion ? "Editar producto" : "Agregar producto",
          style: AppTextStyles.screenTitle,
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
      ),
      backgroundColor: AppColors.background,
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildCampoTexto(
              controller: _nombreController,
              label: "Nombre del producto",
              icon: Icons.inventory_2_outlined,
              validator: (valor) {
                if (valor == null || valor.trim().isEmpty) {
                  return "El nombre es obligatorio";
                }
                return null;
              },
            ),
            const SizedBox(height: 14),

            _buildCampoTexto(
              controller: _descripcionController,
              label: "Descripción (opcional)",
              icon: Icons.description_outlined,
              maxLines: 3,
            ),
            const SizedBox(height: 14),

            _buildCampoTexto(
              controller: _codigoController,
              label: "Código del producto (opcional)",
              icon: Icons.qr_code,
            ),
            const SizedBox(height: 14),

            Row(
              children: [
                Expanded(
                  child: _buildCampoTexto(
                    controller: _precioCompraController,
                    label: "Precio compra",
                    icon: Icons.attach_money,
                    tipoNumerico: true,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildCampoTexto(
                    controller: _precioVentaController,
                    label: "Precio venta",
                    icon: Icons.sell_outlined,
                    tipoNumerico: true,
                    validator: (valor) {
                      if (valor == null || valor.trim().isEmpty) {
                        return "Requerido";
                      }
                      if (double.tryParse(valor.trim()) == null) {
                        return "Número inválido";
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            Row(
              children: [
                Expanded(
                  child: _buildCampoTexto(
                    controller: _stockController,
                    label: "Stock actual",
                    icon: Icons.numbers,
                    tipoNumerico: true,
                    soloEnteros: true,
                    validator: (valor) {
                      if (valor == null || valor.trim().isEmpty) {
                        return "Requerido";
                      }
                      if (int.tryParse(valor.trim()) == null) {
                        return "Debe ser un entero";
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildCampoTexto(
                    controller: _unidadMedidaController,
                    label: "Unidad (ej. unidad, kg)",
                    icon: Icons.straighten,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Switch para el estado (activo/inactivo), igual al patrón que
            // ya usan en CategoriaCard con el booleano "activo"
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text("Producto activo", style: AppTextStyles.cardTitle),
                subtitle: const Text(
                  "Los productos inactivos no aparecen en ventas",
                  style: AppTextStyles.subtitle,
                ),
                value: _estadoActivo,
                activeColor: AppColors.success,
                onChanged: (valor) {
                  setState(() => _estadoActivo = valor);
                },
              ),
            ),
            const SizedBox(height: 28),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _guardarProducto,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  _esEdicion ? "Guardar cambios" : "Agregar producto",
                  style: AppTextStyles.button.copyWith(color: AppColors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Campo de texto reutilizable para no repetir la misma decoración
  /// en cada TextFormField del formulario.
  Widget _buildCampoTexto({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    bool tipoNumerico = false,
    bool soloEnteros = false,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: tipoNumerico
          ? TextInputType.numberWithOptions(decimal: !soloEnteros)
          : TextInputType.text,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.primary),
        filled: true,
        fillColor: AppColors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
      ),
    );
  }
}