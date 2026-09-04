import 'package:flutter/material.dart';

import '../config/app_colors.dart';
import '../config/app_text_styles.dart';
import '../models/categoria.dart';
import '../models/producto.dart';
import '../services/categoria_service.dart';
import '../services/producto_service.dart';

const List<String> _unidadesDisponibles = [
  'Unidad',
  'Libra',
  'Kilogramo',
  'Litro',
  'Paquete',
  'Caja',
];

const Map<String, double> _tasasImpuesto = {
  'Exento (0%)': 0.0,
  '15%': 15.0,
  '18%': 18.0,
};

class FormularioProductoScreen extends StatefulWidget {
  const FormularioProductoScreen({super.key});

  @override
  State<FormularioProductoScreen> createState() =>
      _FormularioProductoScreenState();
}

class _FormularioProductoScreenState extends State<FormularioProductoScreen> {
  final _formKey = GlobalKey<FormState>();

  final ProductoService _productoService = ProductoService();
  final CategoriaService _categoriaService = CategoriaService();

  final _nombreController = TextEditingController();
  final _descripcionController = TextEditingController();
  final _codigoController = TextEditingController();
  final _precioCompraController = TextEditingController();
  final _precioVentaController = TextEditingController();
  final _stockController = TextEditingController(text: '0');

  Producto? _producto;
  Categoria? _categoriaSeleccionada;

  List<Categoria> _categorias = [];

  String? _unidadSeleccionada = _unidadesDisponibles.first;
  String _tasaSeleccionada = '15%';
  bool _estado = true;
  bool _argumentosCargados = false;
  bool cargando = true;

  bool get _esEdicion => _producto != null;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_argumentosCargados) return;
    _argumentosCargados = true;

    _producto = ModalRoute.of(context)?.settings.arguments as Producto?;

    if (_producto != null) {
      _nombreController.text = _producto!.nombreProducto;
      _descripcionController.text = _producto!.descripcion ?? '';
      _codigoController.text = _producto!.codigoProducto ?? '';
      _precioCompraController.text =
          _producto!.precioCompra?.toStringAsFixed(2) ?? '';
      _precioVentaController.text = _producto!.precioVenta.toStringAsFixed(2);
      _stockController.text = _producto!.stockActual.toString();
      _unidadSeleccionada = _producto!.unidadMedida;

      if (!_unidadesDisponibles.contains(_unidadSeleccionada)) {
        _unidadSeleccionada = null;
      }

      _tasaSeleccionada = _tasasImpuesto.entries
          .firstWhere(
            (item) => item.value == _producto!.tasaImpuesto,
            orElse: () => _tasasImpuesto.entries.first,
          )
          .key;

      _estado = _producto!.estado;
    }

    _cargarCategorias();
  }

  Future<void> _cargarCategorias() async {
    try {
      final categorias = await _categoriaService.getCategorias(
        soloActivas: false,
      );

      if (!mounted) return;

      Categoria? seleccionada;

      if (_producto != null) {
        for (final categoria in categorias) {
          if (categoria.id == _producto!.idCategoria) {
            seleccionada = categoria;
            break;
          }
        }
      } else {
        for (final categoria in categorias) {
          if (categoria.activo) {
            seleccionada = categoria;
            break;
          }
        }
      }

      setState(() {
        _categorias = categorias;
        _categoriaSeleccionada = seleccionada;
        cargando = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() => cargando = false);

      _mostrarError('Error al cargar las categorías');
    }
  }

  List<Categoria> get _categoriasDisponibles {
    return _categorias.where((categoria) {
      if (categoria.activo) return true;

      return _producto != null && categoria.id == _producto!.idCategoria;
    }).toList();
  }

  String? _textoOpcional(String valor) {
    final texto = valor.trim();
    return texto.isEmpty ? null : texto;
  }

  double? _numeroOpcional(String valor) {
    final texto = valor.trim().replaceAll(',', '.');

    if (texto.isEmpty) {
      return null;
    }

    return double.tryParse(texto);
  }

  Future<void> _guardarProducto() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_categoriaSeleccionada == null) {
      _mostrarError('Selecciona una categoría');
      return;
    }

    final precioCompra = _numeroOpcional(_precioCompraController.text);

    final precioVenta = double.tryParse(
      _precioVentaController.text.trim().replaceAll(',', '.'),
    );

    final stock = int.tryParse(_stockController.text.trim());

    if (_precioCompraController.text.trim().isNotEmpty &&
        precioCompra == null) {
      _mostrarError('Ingresa un precio de compra válido');
      return;
    }

    if (precioVenta == null || precioVenta < 0) {
      _mostrarError('Ingresa un precio de venta válido');
      return;
    }

    if (precioCompra != null && precioCompra < 0) {
      _mostrarError('Ingresa un precio de compra válido');
      return;
    }

    if (stock == null || stock < 0) {
      _mostrarError('Ingresa un stock válido');
      return;
    }

    final producto = Producto(
      idProducto: _producto?.idProducto,
      idCategoria: _categoriaSeleccionada!.id!,
      nombreProducto: _nombreController.text.trim(),
      descripcion: _textoOpcional(_descripcionController.text),
      // rutaFoto: _producto?.rutaFoto,
      codigoProducto: _textoOpcional(_codigoController.text),
      precioCompra: precioCompra,
      precioVenta: precioVenta,
      stockActual: stock,
      unidadMedida: _unidadSeleccionada,
      tasaImpuesto: _tasasImpuesto[_tasaSeleccionada]!,
      estado: _estado,
    );

    try {
      if (_esEdicion) {
        await _productoService.putProducto(_producto!.idProducto!, producto);
      } else {
        await _productoService.postProducto(producto);
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text('Producto creado correctamente.'),
            backgroundColor: AppColors.success,
          ),
        );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      _mostrarError(
        'Error al ${_esEdicion ? "actualizar" : "crear"} producto.',
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
    final categorias = _categoriasDisponibles;

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
      body: cargando
          ? const Center(child: CircularProgressIndicator())
          : Form(
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
                                  (categoria) => DropdownMenuItem<Categoria>(
                                    value: categoria,
                                    child: Text(categoria.nombre),
                                  ),
                                )
                                .toList(),
                            onChanged: (valor) {
                              setState(() {
                                _categoriaSeleccionada = valor;
                              });
                            },
                            validator: (valor) => valor == null
                                ? 'Selecciona una categoría'
                                : null,
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
                                  (unidad) => DropdownMenuItem<String>(
                                    value: unidad,
                                    child: Text(unidad),
                                  ),
                                )
                                .toList(),
                            onChanged: (valor) {
                              setState(() {
                                _unidadSeleccionada = valor;
                              });
                            },
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
                                  (tasa) => DropdownMenuItem<String>(
                                    value: tasa,
                                    child: Text(tasa),
                                  ),
                                )
                                .toList(),
                            onChanged: (valor) {
                              if (valor == null) return;

                              setState(() {
                                _tasaSeleccionada = valor;
                              });
                            },
                          ),
                          const SizedBox(height: 14),
                          _campoNumero(
                            _stockController,
                            'Stock',
                            requerido: true,
                          ),
                          SwitchListTile(
                            contentPadding: EdgeInsets.zero,
                            activeTrackColor: _esEdicion ? AppColors.success : AppColors.disabled,
                            title: Text(
                              'Estado del producto',
                              style: AppTextStyles.subtitle,
                            ),
                            subtitle: Text(
                              _estado
                                  ? 'Visible en el listado y disponible para venta'
                                  : 'Oculto del listado y no vendible',
                              style: AppTextStyles.subtitle.copyWith(
                                fontSize: 12,
                              ),
                            ),
                            value: _esEdicion ? _estado : true,
                            onChanged: _esEdicion
                                ? (valor) {
                                    setState(() {
                                      _estado = valor;
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
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: _guardarProducto,
                      icon: Icon(_esEdicion ? Icons.save_outlined : Icons.add),
                      label: Text(
                        _esEdicion ? 'Guardar cambios' : 'Crear producto',
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
          ? (valor) {
              if (valor == null || valor.trim().isEmpty) {
                return 'Este campo es obligatorio';
              }

              return null;
            }
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
          ? (valor) {
              if (valor == null || valor.trim().isEmpty) {
                return 'Campo requerido';
              }

              return null;
            }
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
