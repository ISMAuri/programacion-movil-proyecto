import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../config/app_text_styles.dart';

// ---------------------------------------------------------------------------
// Modelos Ejemplo (mientras no hay providers reales conectados)
// ---------------------------------------------------------------------------

class ClienteEjemplo {
  final int id;
  final String nombre;
  const ClienteEjemplo(this.id, this.nombre);
}

class ProductoEjemplo {
  final int id;
  final String nombre;
  final double precioVenta;
  // 0 = exento, 15 o 18 = tasa de ISV
  final double tasaImpuesto;
  const ProductoEjemplo(this.id, this.nombre, this.precioVenta, this.tasaImpuesto);
}

const List<ClienteEjemplo> _clientesEjemplo = [
  ClienteEjemplo(1, "Consumidor Final"),
  ClienteEjemplo(2, "Comercial El Progreso S. de R.L."),
  ClienteEjemplo(3, "María Fernández"),
  ClienteEjemplo(4, "Distribuidora Los Andes"),
];

const List<ProductoEjemplo> _productosEjemplo = [
  ProductoEjemplo(1, "Camisa polo", 250.00, 15),
  ProductoEjemplo(2, "Pan francés (docena)", 35.00, 0),
  ProductoEjemplo(3, "Laptop 14\"", 12500.00, 18),
  ProductoEjemplo(4, "Cuaderno universitario", 45.00, 15),
  ProductoEjemplo(5, "Leche entera 1L", 28.00, 0),
];

const List<String> _metodosPago = ["Efectivo", "Tarjeta", "Transferencia"];
const List<String> _estadosPago = ["Pagado", "Pendiente"];

// ---------------------------------------------------------------------------
// Línea de detalle de venta (estado local, no persistido)
// ---------------------------------------------------------------------------

class _LineaVenta {
  ProductoEjemplo? producto;
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
  const FormularioVentaScreen({
    super.key,
    this.idVenta,
    this.clienteInicial,
    this.numeroFactura,
    this.metodoPagoInicial,
    this.estadoPagoInicial,
  });

  // null en idVenta -> modo crear. Con dato -> modo editar.
  final int? idVenta;
  final ClienteEjemplo? clienteInicial;
  final String? numeroFactura;
  final String? metodoPagoInicial;
  final String? estadoPagoInicial;

  bool get esEdicion => idVenta != null;

  @override
  State<FormularioVentaScreen> createState() => _FormularioVentaScreenState();
}

class _FormularioVentaScreenState extends State<FormularioVentaScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _facturaController;

  ClienteEjemplo? _clienteSeleccionado;
  String _metodoPago = _metodosPago.first;
  String _estadoPago = _estadosPago.first;
  DateTime _fechaVenta = DateTime.now();

  final List<_LineaVenta> _lineas = [_LineaVenta()];

  @override
  void initState() {
    super.initState();
    _facturaController = TextEditingController(
      text: widget.numeroFactura ?? "",
    );
    _clienteSeleccionado = widget.clienteInicial;
    _metodoPago = widget.metodoPagoInicial ?? _metodosPago.first;
    _estadoPago = widget.estadoPagoInicial ?? _estadosPago.first;
  }

  @override
  void dispose() {
    _facturaController.dispose();
    super.dispose();
  }

  // ---- Totales -------------------------------------------------------

  double get _totalExento =>
      _lineas.fold(0, (acc, l) => acc + l.baseExenta);
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
    if (!_formKey.currentState!.validate()) return;
    if (_clienteSeleccionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Selecciona un cliente")),
      );
      return;
    }
    if (_lineas.any((l) => l.producto == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Completa todos los productos de la venta")),
      );
      return;
    }
    // Validar y guardar la venta (crear o actualizar), junto a detalle_venta
  }

  // ---- UI ----------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          widget.esEdicion ? "Editar venta" : "Nueva venta",
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
            _buildDatosGeneralesCard(),
            const SizedBox(height: 16),
            _buildProductosCard(),
            const SizedBox(height: 16),
            _buildTotalesCard(),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _guardarVenta,
                icon: Icon(
                  widget.esEdicion ? Icons.save_outlined : Icons.point_of_sale,
                ),
                label: Text(
                  widget.esEdicion ? "Guardar cambios" : "Registrar venta",
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
            DropdownButtonFormField<ClienteEjemplo>(
              initialValue: _clienteSeleccionado,
              decoration: const InputDecoration(
                labelText: "Cliente",
                prefixIcon: Icon(Icons.person_outline),
              ),
              items: _clientesEjemplo
                  .map(
                    (c) => DropdownMenuItem(value: c, child: Text(c.nombre)),
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
                        .map(
                          (m) => DropdownMenuItem(value: m, child: Text(m)),
                        )
                        .toList(),
                    onChanged: (valor) =>
                        setState(() => _metodoPago = valor!),
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
                        .map(
                          (e) => DropdownMenuItem(value: e, child: Text(e)),
                        )
                        .toList(),
                    onChanged: (valor) =>
                        setState(() => _estadoPago = valor!),
                  ),
                ),
              ],
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
                  style: TextButton.styleFrom(foregroundColor: AppColors.primary),
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
              child: DropdownButtonFormField<ProductoEjemplo>(
                initialValue: linea.producto,
                isExpanded: true,
                decoration: const InputDecoration(
                  labelText: "Producto",
                  prefixIcon: Icon(Icons.inventory_2_outlined),
                ),
                items: _productosEjemplo
                    .map(
                      (p) => DropdownMenuItem(
                        value: p,
                        child: Text(
                          "${p.nombre} · ${_lps(p.precioVenta)}",
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (valor) =>
                    setState(() => linea.producto = valor),
                validator: (valor) =>
                    valor == null ? "Selecciona un producto" : null,
              ),
            ),
            IconButton(
              onPressed:
                  _lineas.length == 1 ? null : () => _eliminarLinea(index),
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
            if (_totalGravado15 > 0)
              _filaTotal("Gravado 15%", _totalGravado15),
            if (_totalGravado18 > 0)
              _filaTotal("Gravado 18%", _totalGravado18),
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