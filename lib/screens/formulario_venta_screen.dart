import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../config/app_text_styles.dart';
import '../models/cliente_model.dart';
import '../models/producto_model.dart';
import '../models/venta_model.dart';

final List<Cliente> _clientes = [
  Cliente(
    idCliente: 1,
    nombreCliente: "Consumidor Final",
    rtn: "",
    direccion: "",
    telefono: "",
    correo: "",
    fechaRegistro: DateTime(2026, 1, 1),
    estado: true,
  ),
  Cliente(
    idCliente: 2,
    nombreCliente: "Comercial El Progreso S. de R.L.",
    rtn: "08019000000000",
    direccion: "El Progreso",
    telefono: "9999-0001",
    correo: "ventas@elprogreso.hn",
    fechaRegistro: DateTime(2026, 1, 2),
    estado: true,
  ),
  Cliente(
    idCliente: 3,
    nombreCliente: "María Fernández",
    rtn: "08011999000001",
    direccion: "Tegucigalpa",
    telefono: "9999-0002",
    correo: "maria@email.com",
    fechaRegistro: DateTime(2026, 1, 3),
    estado: true,
  ),
];

final List<Producto> _productos = [
  Producto(
    idProducto: 1,
    idCategoria: 1,
    categoria: "Ropa",
    nombreProducto: "Camisa polo",
    descripcion: "",
    codigoProducto: "ROP-001",
    precioCompra: 180,
    precioVenta: 250,
    stockActual: 20,
    unidadMedida: "Unidad",
    tasaImpuesto: 15,
    estado: true,
  ),
  Producto(
    idProducto: 2,
    idCategoria: 2,
    categoria: "Panadería",
    nombreProducto: "Pan francés (docena)",
    descripcion: "",
    codigoProducto: "PAN-001",
    precioCompra: 25,
    precioVenta: 35,
    stockActual: 30,
    unidadMedida: "Docena",
    tasaImpuesto: 0,
    estado: true,
  ),
  Producto(
    idProducto: 3,
    idCategoria: 3,
    categoria: "Tecnología",
    nombreProducto: "Laptop 14\"",
    descripcion: "",
    codigoProducto: "TEC-001",
    precioCompra: 10000,
    precioVenta: 12500,
    stockActual: 5,
    unidadMedida: "Unidad",
    tasaImpuesto: 18,
    estado: true,
  ),
  Producto(
    idProducto: 4,
    idCategoria: 4,
    categoria: "Papelería",
    nombreProducto: "Cuaderno universitario",
    descripcion: "",
    codigoProducto: "PAP-001",
    precioCompra: 30,
    precioVenta: 45,
    stockActual: 40,
    unidadMedida: "Unidad",
    tasaImpuesto: 15,
    estado: true,
  ),
  Producto(
    idProducto: 5,
    idCategoria: 5,
    categoria: "Lácteos",
    nombreProducto: "Leche entera 1L",
    descripcion: "",
    codigoProducto: "LAC-001",
    precioCompra: 22,
    precioVenta: 28,
    stockActual: 25,
    unidadMedida: "Litro",
    tasaImpuesto: 0,
    estado: true,
  ),
];

// Estos son los metodos de pago que maneja Inversiones Sammy
const List<String> _metodosPago = [
  "Efectivo",
  "Tarjeta",
  "Transferencia",
  "Cheque",
];
const List<String> _estadosPago = ["Pagado", "Anulado"];

// ---------------------------------------------------------------------------
// Línea de detalle de venta
// ---------------------------------------------------------------------------

class _LineaVenta {
  Producto? producto;
  int cantidad;

  _LineaVenta({this.producto, this.cantidad = 1});

  double get subtotal => (producto?.precioVenta ?? 0) * cantidad;

  double get montoImpuesto =>
      producto == null ? 0 : subtotal * (producto!.tasaImpuesto / 100);

  double get baseExenta => (producto?.tasaImpuesto == 0) ? subtotal : 0;
  double get baseGravada15 => (producto?.tasaImpuesto == 15) ? subtotal : 0;
  double get baseGravada18 => (producto?.tasaImpuesto == 18) ? subtotal : 0;
  double get isv15 => (producto?.tasaImpuesto == 15) ? montoImpuesto : 0;
  double get isv18 => (producto?.tasaImpuesto == 18) ? montoImpuesto : 0;
}

// ---------------------------------------------------------------------------
// Screen
// ---------------------------------------------------------------------------

class FormularioVentaScreen extends StatefulWidget {
  const FormularioVentaScreen({super.key});

  @override
  State<FormularioVentaScreen> createState() => _FormularioVentaScreenState();
}

class _FormularioVentaScreenState extends State<FormularioVentaScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _facturaController = TextEditingController();

  Venta? _venta;
  Cliente? _clienteSeleccionado;
  String _metodoPago = _metodosPago.first;
  String _estadoPago = _estadosPago.first;
  DateTime _fechaVenta = DateTime.now();

  final List<_LineaVenta> _lineas = [_LineaVenta()];
  bool _estado = true;
  bool _argumentosCargados = false;

  bool get _esEdicion => _venta != null;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_argumentosCargados) return;
    _argumentosCargados = true;

    _venta = ModalRoute.of(context)?.settings.arguments as Venta?;
    if (_venta == null) return;

    _facturaController.text = _venta!.numeroFactura;
    final indiceCliente = _clientes.indexWhere(
      (cliente) => cliente.idCliente == _venta!.idCliente,
    );
    if (indiceCliente >= 0) {
      _clienteSeleccionado = _clientes[indiceCliente];
    } else {
      final clienteVenta = Cliente(
        idCliente: _venta!.idCliente,
        nombreCliente: _venta!.nombreCliente,
        rtn: "",
        direccion: "",
        telefono: "",
        correo: "",
        fechaRegistro: _venta!.fechaVenta,
        estado: true,
      );
      _clientes.add(clienteVenta);
      _clienteSeleccionado = clienteVenta;
    }
    _metodoPago = _venta!.metodoPago;
    _estadoPago = _venta!.estadoPago;
    _fechaVenta = _venta!.fechaVenta;
    _estado = _venta!.estado;

    _lineas
      ..clear()
      ..addAll(
        _venta!.detalles.map((detalle) {
          final indiceProducto = _productos.indexWhere(
            (producto) => producto.idProducto == detalle.idProducto,
          );

          Producto producto;
          if (indiceProducto >= 0) {
            producto = _productos[indiceProducto];
          } else {
            producto = Producto(
              idProducto: detalle.idProducto,
              idCategoria: 0,
              categoria: "Sin categoría",
              nombreProducto: detalle.nombreProducto,
              descripcion: "",
              codigoProducto: "",
              precioCompra: 0,
              precioVenta: detalle.precioUnitario,
              stockActual: 0,
              unidadMedida: "Unidad",
              tasaImpuesto: detalle.tasaImpuesto,
              estado: true,
            );
            _productos.add(producto);
          }

          return _LineaVenta(producto: producto, cantidad: detalle.cantidad);
        }),
      );

    if (_lineas.isEmpty) _lineas.add(_LineaVenta());
  }

  @override
  void dispose() {
    _facturaController.dispose();
    super.dispose();
  }

  // ---- Totales -------------------------------------------------------

  double get _totalExento => _lineas.fold(0, (acc, l) => acc + l.baseExenta);
  double get _totalGravado15 =>
      _lineas.fold(0, (acc, l) => acc + l.baseGravada15);
  double get _totalGravado18 =>
      _lineas.fold(0, (acc, l) => acc + l.baseGravada18);
  double get _totalIsv15 => _lineas.fold(0, (acc, l) => acc + l.isv15);
  double get _totalIsv18 => _lineas.fold(0, (acc, l) => acc + l.isv18);
  double get _subtotal => _lineas.fold(0, (acc, l) => acc + l.subtotal);
  double get _total => _subtotal + _totalIsv15 + _totalIsv18;

  String _lps(double valor) => "L. ${valor.toStringAsFixed(2)}";

  // ---- Acciones --------------------------------------------------------

  void _agregarLinea() {
    setState(() => _lineas.add(_LineaVenta()));
  }

  void _eliminarLinea(int index) {
    if (_lineas.length == 1) return;
    setState(() => _lineas.removeAt(index));
  }

  Future<void> _seleccionarFecha() async {
    final seleccionada = await showDatePicker(
      context: context,
      initialDate: _fechaVenta,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (seleccionada != null) {
      setState(() => _fechaVenta = seleccionada);
    }
  }

  void _guardarVenta() {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text("Completa los datos obligatorios de la venta"),
            backgroundColor: AppColors.error,
          ),
        );
      return;
    }
    if (_clienteSeleccionado == null) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text("Selecciona un cliente"),
            backgroundColor: AppColors.error,
          ),
        );
      return;
    }
    if (_lineas.any((l) => l.producto == null)) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text("Completa todos los productos de la venta"),
            backgroundColor: AppColors.error,
          ),
        );
      return;
    }

    Navigator.pop(context, true);
  }

  // ---- UI ----------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          _esEdicion ? "Editar venta" : "Nueva venta",
          style: AppTextStyles.screenTitle,
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  _buildDatosGeneralesCard(),
                  const SizedBox(height: 16),
                  _buildProductosCard(),
                  const SizedBox(height: 16),
                  _buildTotalesCard(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
              color: AppColors.white,
              child: SafeArea(
                top: false,
                child: SizedBox(
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: _guardarVenta,
                    icon: Icon(
                      _esEdicion ? Icons.save_outlined : Icons.point_of_sale,
                    ),
                    label: Text(
                      _esEdicion ? "Guardar cambios" : "Registrar venta",
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
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDatosGeneralesCard() {
    return Card(
      elevation: 2,
      color: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Datos de la venta", style: AppTextStyles.sectionTitle),
            const SizedBox(height: 14),
            DropdownButtonFormField<Cliente>(
              initialValue: _clienteSeleccionado,
              decoration: const InputDecoration(
                labelText: "Cliente",
                prefixIcon: Icon(Icons.person_outline),
              ),
              items: _clientes
                  .where((c) => c.estado)
                  .map(
                    (c) => DropdownMenuItem(
                      value: c,
                      child: Text(c.nombreCliente),
                    ),
                  )
                  .toList(),
              onChanged: (valor) =>
                  setState(() => _clienteSeleccionado = valor),
              validator: (valor) =>
                  valor == null ? "Selecciona un cliente" : null,
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _facturaController,
              decoration: const InputDecoration(
                labelText: "Número de factura",
                prefixIcon: Icon(Icons.receipt_long_outlined),
              ),
              validator: (valor) => (valor == null || valor.trim().isEmpty)
                  ? "Ingresa el número de factura"
                  : null,
            ),
            const SizedBox(height: 14),
            InkWell(
              onTap: _seleccionarFecha,
              borderRadius: BorderRadius.circular(8),
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: "Fecha de venta",
                  prefixIcon: Icon(Icons.calendar_today_outlined),
                ),
                child: Text(
                  "${_fechaVenta.day.toString().padLeft(2, '0')}/"
                  "${_fechaVenta.month.toString().padLeft(2, '0')}/"
                  "${_fechaVenta.year}",
                ),
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    isExpanded: true,
                    initialValue: _metodoPago,
                    decoration: const InputDecoration(
                      labelText: "Método de pago",
                      prefixIcon: Icon(Icons.payments_outlined),
                    ),
                    items: _metodosPago
                        .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                        .toList(),
                    onChanged: (valor) => setState(() => _metodoPago = valor!),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    isExpanded: true,
                    initialValue: _estadoPago,
                    decoration: const InputDecoration(
                      labelText: "Estado de pago",
                      prefixIcon: Icon(Icons.flag_outlined),
                    ),
                    items: _estadosPago
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (valor) => setState(() => _estadoPago = valor!),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text("Estado de la venta"),
              subtitle: Text(_estado ? "Activa" : "Inactiva"),
              value: _estado,
              activeColor: AppColors.primary,
              onChanged: (valor) => setState(() => _estado = valor),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductosCard() {
    return Card(
      elevation: 2,
      color: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Productos", style: AppTextStyles.sectionTitle),
                TextButton.icon(
                  onPressed: _agregarLinea,
                  icon: const Icon(Icons.add),
                  label: const Text("Agregar"),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primary,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            for (int i = 0; i < _lineas.length; i++) ...[
              _buildLineaProducto(i),
              if (i != _lineas.length - 1) const Divider(height: 24),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLineaProducto(int index) {
    final linea = _lineas[index];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<Producto>(
                initialValue: linea.producto,
                isExpanded: true,
                decoration: const InputDecoration(
                  labelText: "Producto",
                  prefixIcon: Icon(Icons.inventory_2_outlined),
                ),
                items: _productos
                    .where((p) => p.estado)
                    .map(
                      (p) => DropdownMenuItem(
                        value: p,
                        child: Text(
                          "${p.nombreProducto} · ${_lps(p.precioVenta)}",
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (valor) => setState(() => linea.producto = valor),
                validator: (valor) =>
                    valor == null ? "Selecciona un producto" : null,
              ),
            ),
            IconButton(
              onPressed: _lineas.length == 1
                  ? null
                  : () => _eliminarLinea(index),
              icon: const Icon(Icons.delete_outline),
              color: AppColors.error,
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Text("Cantidad", style: AppTextStyles.subtitle),
            const Spacer(),
            IconButton(
              onPressed: linea.cantidad > 1
                  ? () => setState(() => linea.cantidad--)
                  : null,
              icon: const Icon(Icons.remove_circle_outline),
            ),
            Text("${linea.cantidad}", style: AppTextStyles.cardTitle),
            IconButton(
              onPressed: () => setState(() => linea.cantidad++),
              icon: const Icon(Icons.add_circle_outline),
              color: AppColors.primary,
            ),
            const SizedBox(width: 8),
            Text(_lps(linea.subtotal), style: AppTextStyles.price),
          ],
        ),
      ],
    );
  }

  Widget _buildTotalesCard() {
    return Card(
      elevation: 2,
      color: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Resumen", style: AppTextStyles.sectionTitle),
            const SizedBox(height: 12),
            _filaTotal("Subtotal", _subtotal),
            if (_totalExento > 0) _filaTotal("Exento", _totalExento),
            if (_totalGravado15 > 0) _filaTotal("Gravado 15%", _totalGravado15),
            if (_totalGravado18 > 0) _filaTotal("Gravado 18%", _totalGravado18),
            if (_totalIsv15 > 0) _filaTotal("ISV 15%", _totalIsv15),
            if (_totalIsv18 > 0) _filaTotal("ISV 18%", _totalIsv18),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Total", style: AppTextStyles.cardTitle),
                Text(
                  _lps(_total),
                  style: AppTextStyles.statistic.copyWith(
                    fontSize: 22,
                    color: AppColors.success,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _filaTotal(String etiqueta, double valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(etiqueta, style: AppTextStyles.subtitle),
          Text(_lps(valor), style: AppTextStyles.subtitle),
        ],
      ),
    );
  }
}
