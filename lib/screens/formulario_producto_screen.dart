import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../config/app_text_styles.dart';
import '../models/categoria_model.dart';
import '../models/producto_model.dart';

const List<Categoria> _categoriasDisponibles = [
  Categoria(
    idCategoria: 1,
    nombreCategoria: 'Lácteos',
    descripcion: null,
    estado: true,
  ),
  Categoria(
    idCategoria: 2,
    nombreCategoria: 'Cereales',
    descripcion: null,
    estado: true,
  ),
  Categoria(
    idCategoria: 3,
    nombreCategoria: 'Bebidas',
    descripcion: null,
    estado: true,
  ),
  Categoria(
    idCategoria: 4,
    nombreCategoria: 'Limpieza',
    descripcion: null,
    estado: true,
  ),
];

const _unidadesDisponibles = [
  'Unidad',
  'Libra',
  'Kilogramo',
  'Litro',
  'Paquete',
  'Caja',
];

const _tasasImpuesto = {'Exento (0%)': 0.0, '15%': 15.0, '18%': 18.0};

class FormularioProductoScreen extends StatefulWidget {
  const FormularioProductoScreen({
    super.key,
    this.producto,
    this.categorias = _categoriasDisponibles,
  });

  final Producto? producto;
  final List<Categoria> categorias;

  @override
  State<FormularioProductoScreen> createState() =>
      _FormularioProductoScreenState();
}

class _FormularioProductoScreenState extends State<FormularioProductoScreen> {
  final _formKey = GlobalKey<FormState>();
  Producto? _producto;
  bool _argumentosCargados = false;
  Categoria? _categoriaSeleccionada;
  String? _unidadSeleccionada = _unidadesDisponibles.first;
  String _tasaSeleccionada = '15%';
  bool _estado = true;

  bool get _esEdicion => _producto != null;

  final _nombreController = TextEditingController();
  final _descripcionController = TextEditingController();
  final _codigoController = TextEditingController();
  final _precioCompraController = TextEditingController();
  final _precioVentaController = TextEditingController();
  final _stockController = TextEditingController(text: '0');

  @override
  void initState() {
    super.initState();
    final activas = widget.categorias.where((categoria) => categoria.estado);
    if (activas.isNotEmpty) _categoriaSeleccionada = activas.first;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_argumentosCargados) return;
    _argumentosCargados = true;

    _producto =
        widget.producto ??
        ModalRoute.of(context)?.settings.arguments as Producto?;
    final producto = _producto;
    if (producto == null) return;

    for (final categoria in widget.categorias) {
      if (categoria.idCategoria == producto.idCategoria) {
        _categoriaSeleccionada = categoria;
        break;
      }
    }
    _unidadSeleccionada = producto.unidadMedida;
    _tasaSeleccionada = _tasasImpuesto.entries
        .firstWhere(
          (item) => item.value == producto.tasaImpuesto,
          orElse: () => _tasasImpuesto.entries.first,
        )
        .key;
    _estado = producto.estado;
    _nombreController.text = producto.nombreProducto;
    _descripcionController.text = producto.descripcion ?? '';
    _codigoController.text = producto.codigoProducto ?? '';
    _precioCompraController.text =
        producto.precioCompra?.toStringAsFixed(2) ?? '';
    _precioVentaController.text = producto.precioVenta.toStringAsFixed(2);
    _stockController.text = producto.stockActual.toString();
  }

  String? _textoOpcional(String valor) {
    final texto = valor.trim();
    return texto.isEmpty ? null : texto;
  }

  double? _numeroOpcional(String valor) {
    final texto = valor.trim().replaceAll(',', '.');
    return texto.isEmpty ? null : double.tryParse(texto);
  }

  void _mostrarError(String mensaje) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(mensaje), backgroundColor: AppColors.error),
      );
  }

  void _guardarProducto() {
    if (!_formKey.currentState!.validate()) return;
    if (_categoriaSeleccionada == null) {
      _mostrarError('Selecciona una categoría');
      return;
    }

    final compra = _numeroOpcional(_precioCompraController.text);
    final venta = double.tryParse(
      _precioVentaController.text.trim().replaceAll(',', '.'),
    );
    final stock = int.tryParse(_stockController.text.trim());
    if ((_precioCompraController.text.trim().isNotEmpty && compra == null) ||
        venta == null ||
        stock == null ||
        (compra != null && compra < 0) ||
        venta < 0 ||
        stock < 0) {
      _mostrarError('Ingresa precios y stock válidos');
      return;
    }

    Navigator.pop(
      context,
      Producto(
        idProducto: _producto?.idProducto,
        idCategoria: _categoriaSeleccionada!.idCategoria,
        nombreProducto: _nombreController.text.trim(),
        descripcion: _textoOpcional(_descripcionController.text),
        rutaFoto: _producto?.rutaFoto,
        codigoProducto: _textoOpcional(_codigoController.text),
        precioCompra: compra,
        precioVenta: venta,
        stockActual: stock,
        unidadMedida: _unidadSeleccionada,
        tasaImpuesto: _tasasImpuesto[_tasaSeleccionada]!,
        estado: _estado,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final categorias = widget.categorias
        .where((categoria) => categoria.estado)
        .toList();
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          _esEdicion ? 'Editar producto' : 'Nuevo producto',
          style: AppTextStyles.screenTitle,
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
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
                    _campo(
                      _nombreController,
                      'Nombre del producto',
                      Icons.label_outline,
                      requerido: true,
                    ),
                    const SizedBox(height: 14),
                    _campo(
                      _descripcionController,
                      'Descripción (opcional)',
                      Icons.notes_outlined,
                      lineas: 2,
                    ),
                    const SizedBox(height: 14),
                    _campo(
                      _codigoController,
                      'Código del producto (opcional)',
                      Icons.qr_code_outlined,
                    ),
                    const SizedBox(height: 14),
                    DropdownButtonFormField<Categoria>(
                      value: categorias.contains(_categoriaSeleccionada)
                          ? _categoriaSeleccionada
                          : null,
                      decoration: const InputDecoration(
                        labelText: 'Categoría',
                        prefixIcon: Icon(Icons.category_outlined),
                      ),
                      items: categorias
                          .map(
                            (categoria) => DropdownMenuItem(
                              value: categoria,
                              child: Text(categoria.nombreCategoria),
                            ),
                          )
                          .toList(),
                      onChanged: (valor) =>
                          setState(() => _categoriaSeleccionada = valor),
                    ),
                    const SizedBox(height: 14),
                    DropdownButtonFormField<String>(
                      value: _unidadSeleccionada,
                      decoration: const InputDecoration(
                        labelText: 'Unidad de medida (opcional)',
                        prefixIcon: Icon(Icons.straighten_outlined),
                      ),
                      items: _unidadesDisponibles
                          .map(
                            (unidad) => DropdownMenuItem(
                              value: unidad,
                              child: Text(unidad),
                            ),
                          )
                          .toList(),
                      onChanged: (valor) =>
                          setState(() => _unidadSeleccionada = valor),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: _campoNumero(
                            _precioCompraController,
                            'Precio compra (opcional)',
                            decimal: true,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _campoNumero(
                            _precioVentaController,
                            'Precio venta',
                            requerido: true,
                            decimal: true,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    DropdownButtonFormField<String>(
                      value: _tasaSeleccionada,
                      decoration: const InputDecoration(
                        labelText: 'Tasa de ISV',
                        prefixIcon: Icon(Icons.percent_outlined),
                      ),
                      items: _tasasImpuesto.keys
                          .map(
                            (tasa) => DropdownMenuItem(
                              value: tasa,
                              child: Text(tasa),
                            ),
                          )
                          .toList(),
                      onChanged: (valor) {
                        if (valor != null) {
                          setState(() => _tasaSeleccionada = valor);
                        }
                      },
                    ),
                    const SizedBox(height: 14),
                    _campoNumero(_stockController, 'Stock', requerido: true),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      activeTrackColor: AppColors.success,
                      title: Text(
                        'Estado del producto',
                        style: AppTextStyles.subtitle,
                      ),
                      subtitle: Text(
                        _estado
                            ? 'Visible en el listado y disponible para venta'
                            : 'Oculto del listado y no vendible',
                        style: AppTextStyles.subtitle.copyWith(fontSize: 12),
                      ),
                      value: _estado,
                      onChanged: (valor) => setState(() => _estado = valor),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _guardarProducto,
                icon: Icon(_esEdicion ? Icons.save_outlined : Icons.add),
                label: Text(_esEdicion ? 'Guardar cambios' : 'Crear producto'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextFormField _campo(
    TextEditingController controller,
    String etiqueta,
    IconData icono, {
    bool requerido = false,
    int lineas = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: lineas,
      decoration: InputDecoration(labelText: etiqueta, prefixIcon: Icon(icono)),
      validator: requerido
          ? (valor) => valor == null || valor.trim().isEmpty
                ? 'Este campo es obligatorio'
                : null
          : null,
    );
  }

  TextFormField _campoNumero(
    TextEditingController controller,
    String etiqueta, {
    bool requerido = false,
    bool decimal = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.numberWithOptions(decimal: decimal),
      decoration: InputDecoration(
        labelText: etiqueta,
        prefixText: etiqueta.startsWith('Precio') ? 'L. ' : null,
        prefixIcon: etiqueta == 'Stock'
            ? const Icon(Icons.inventory_2_outlined)
            : null,
      ),
      validator: requerido
          ? (valor) =>
                valor == null || valor.trim().isEmpty ? 'Campo requerido' : null
          : null,
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
