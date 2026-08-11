import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../config/app_text_styles.dart';

// Ejemplo estático de categorías (en la app real vendría de la tabla categoria)
const List<String> _categoriasDisponibles = [
  "Lácteos",
  "Cereales",
  "Proteínas",
  "Bebidas",
  "Postres",
  "Limpieza",
];

const List<String> _unidadesDisponibles = [
  "Unidad",
  "Libra",
  "Kilogramo",
  "Litro",
  "Paquete",
  "Caja",
];

// Tasas de ISV vigentes en Honduras: exento, 15% y 18% (bebidas alcohólicas/tabaco)
const Map<String, double> _tasasImpuesto = {
  "Exento (0%)": 0.0,
  "15%": 15.0,
  "18%": 18.0,
};

class FormularioProductoScreen extends StatefulWidget {
  const FormularioProductoScreen({
    super.key,
    this.categoria,
    this.nombreProducto,
    this.descripcion,
    this.codigoProducto,
    this.precioCompra,
    this.precioVenta,
    this.stockActual,
    this.unidadMedida,
    this.tasaImpuesto,
    this.activo,
  });

  // null en nombreProducto -> modo crear. Con datos -> modo editar.
  final String? categoria;
  final String? nombreProducto;
  final String? descripcion;
  final String? codigoProducto;
  final double? precioCompra;
  final double? precioVenta;
  final int? stockActual;
  final String? unidadMedida;
  final double? tasaImpuesto;
  final bool? activo;

  bool get esEdicion => nombreProducto != null;

  @override
  State<FormularioProductoScreen> createState() =>
      _FormularioProductoScreenState();
}

class _FormularioProductoScreenState extends State<FormularioProductoScreen> {
  late String _categoriaSeleccionada;
  late String _unidadSeleccionada;
  late String _tasaSeleccionada;
  late bool _activo;

  late final TextEditingController _nombreController;
  late final TextEditingController _descripcionController;
  late final TextEditingController _codigoController;
  late final TextEditingController _precioCompraController;
  late final TextEditingController _precioVentaController;
  late final TextEditingController _stockController;

  void _guardarProducto() {
    final nombre = _nombreController.text.trim();
    final descripcion = _descripcionController.text.trim();
    final codigo = _codigoController.text.trim();
    final precioCompraTexto = _precioCompraController.text.trim();
    final precioVentaTexto = _precioVentaController.text.trim();
    final stockTexto = _stockController.text.trim();

    if (nombre.isEmpty ||
        descripcion.isEmpty ||
        codigo.isEmpty ||
        precioCompraTexto.isEmpty ||
        precioVentaTexto.isEmpty ||
        (!widget.esEdicion && stockTexto.isEmpty)) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text("Completa todos los campos del producto"),
            backgroundColor: AppColors.error,
          ),
        );
      return;
    }

    final precioCompra = double.tryParse(
      precioCompraTexto.replaceAll(",", "."),
    );
    final precioVenta = double.tryParse(precioVentaTexto.replaceAll(",", "."));
    final stock = widget.esEdicion
        ? (widget.stockActual ?? 0)
        : int.tryParse(stockTexto);

    if (precioCompra == null ||
        precioVenta == null ||
        stock == null ||
        precioCompra < 0 ||
        precioVenta < 0 ||
        stock < 0) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text("Ingresa precios y stock válidos"),
            backgroundColor: AppColors.error,
          ),
        );
      return;
    }

    final mensaje =
        "Producto ${widget.esEdicion ? "actualizado" : "creado"} correctamente";

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(mensaje), backgroundColor: AppColors.success),
      );

    Navigator.pop(context, true);
  }

  @override
  void initState() {
    super.initState();
    _categoriaSeleccionada = widget.categoria ?? _categoriasDisponibles.first;
    _unidadSeleccionada = widget.unidadMedida ?? _unidadesDisponibles.first;
    _tasaSeleccionada = _tasasImpuesto.entries
        .firstWhere(
          (e) => e.value == (widget.tasaImpuesto ?? 15.0),
          orElse: () => _tasasImpuesto.entries.first,
        )
        .key;
    _activo = widget.activo ?? true;

    _nombreController = TextEditingController(
      text: widget.nombreProducto ?? "",
    );
    _descripcionController = TextEditingController(
      text: widget.descripcion ?? "",
    );
    _codigoController = TextEditingController(
      text: widget.codigoProducto ?? "",
    );
    _precioCompraController = TextEditingController(
      text: widget.precioCompra?.toStringAsFixed(2) ?? "",
    );
    _precioVentaController = TextEditingController(
      text: widget.precioVenta?.toStringAsFixed(2) ?? "",
    );
    _stockController = TextEditingController(
      text: widget.stockActual?.toString() ?? "",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          widget.esEdicion ? "Editar producto" : "Nuevo producto",
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
                      labelText: "Nombre del producto",
                      prefixIcon: Icon(Icons.label_outline),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _descripcionController,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      labelText: "Descripción",
                      alignLabelWithHint: true,
                      prefixIcon: Icon(Icons.notes_outlined),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _codigoController,
                    decoration: const InputDecoration(
                      labelText: "Código del producto",
                      prefixIcon: Icon(Icons.qr_code_outlined),
                    ),
                  ),
                  const SizedBox(height: 14),
                  DropdownButtonFormField<String>(
                    initialValue: _categoriaSeleccionada,
                    decoration: const InputDecoration(
                      labelText: "Categoría",
                      prefixIcon: Icon(Icons.category_outlined),
                    ),
                    items: _categoriasDisponibles
                        .map(
                          (cat) =>
                              DropdownMenuItem(value: cat, child: Text(cat)),
                        )
                        .toList(),
                    onChanged: (valor) {
                      if (valor != null) {
                        setState(() => _categoriaSeleccionada = valor);
                      }
                    },
                  ),
                  const SizedBox(height: 14),
                  DropdownButtonFormField<String>(
                    initialValue: _unidadSeleccionada,
                    decoration: const InputDecoration(
                      labelText: "Unidad de medida",
                      prefixIcon: Icon(Icons.straighten_outlined),
                    ),
                    items: _unidadesDisponibles
                        .map((u) => DropdownMenuItem(value: u, child: Text(u)))
                        .toList(),
                    onChanged: (valor) {
                      if (valor != null) {
                        setState(() => _unidadSeleccionada = valor);
                      }
                    },
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _precioCompraController,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          decoration: const InputDecoration(
                            labelText: "Precio compra",
                            prefixText: "L. ",
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _precioVentaController,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          decoration: const InputDecoration(
                            labelText: "Precio venta",
                            prefixText: "L. ",
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  DropdownButtonFormField<String>(
                    initialValue: _tasaSeleccionada,
                    decoration: const InputDecoration(
                      labelText: "Tasa de ISV",
                      prefixIcon: Icon(Icons.percent_outlined),
                    ),
                    items: _tasasImpuesto.keys
                        .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                        .toList(),
                    onChanged: (valor) {
                      if (valor != null) {
                        setState(() => _tasaSeleccionada = valor);
                      }
                    },
                  ),
                  const SizedBox(height: 14),

                  // Stock: solo editable al crear. En edición, el número
                  // solo debe cambiar a través de un movimiento de inventario,
                  // para no perder la trazabilidad de entradas/salidas.
                  if (!widget.esEdicion)
                    TextFormField(
                      controller: _stockController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Stock inicial",
                        prefixIcon: Icon(Icons.inventory_2_outlined),
                      ),
                    )
                  else
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.inventory_2_outlined,
                            color: AppColors.disabled,
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Stock actual: ${widget.stockActual ?? 0}",
                                  style: AppTextStyles.cardTitle.copyWith(
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  "Se ajusta desde Movimientos, no aquí",
                                  style: AppTextStyles.subtitle.copyWith(
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 8),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    activeTrackColor: AppColors.success,
                    title: Text(
                      "Producto activo",
                      style: AppTextStyles.subtitle,
                    ),
                    subtitle: Text(
                      _activo
                          ? "Visible en el listado y disponible para venta"
                          : "Oculto del listado y no vendible",
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
              onPressed: _guardarProducto,
              icon: Icon(widget.esEdicion ? Icons.save_outlined : Icons.add),
              label: Text(
                widget.esEdicion ? "Guardar cambios" : "Crear producto",
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
    _codigoController.dispose();
    _precioCompraController.dispose();
    _precioVentaController.dispose();
    _stockController.dispose();
    super.dispose();
  }
}
