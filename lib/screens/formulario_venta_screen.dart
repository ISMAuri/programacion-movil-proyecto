import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../config/app_text_styles.dart';
import '../models/cliente_model.dart';
import '../models/detalle_venta_model.dart';
import '../models/producto_model.dart';
import '../models/venta_model.dart';

final List<Cliente> _clientes = [
  Cliente(
    idCliente: 1,
    nombreCliente: 'Consumidor Final',
    rtn: null,
    direccion: null,
    telefono: null,
    correo: null,
    fechaRegistro: DateTime(2026, 1, 1),
    estado: true,
  ),
  Cliente(
    idCliente: 2,
    nombreCliente: 'Comercial El Progreso S. de R.L.',
    rtn: '08019000000000',
    direccion: 'El Progreso',
    telefono: '9999-0001',
    correo: 'ventas@elprogreso.hn',
    fechaRegistro: DateTime(2026, 1, 2),
    estado: true,
  ),
];

final List<Producto> _productos = [
  const Producto(
    idProducto: 1,
    idCategoria: 1,
    nombreProducto: 'Aceite vegetal 1 L',
    codigoProducto: 'ALI-001',
    precioCompra: 75,
    precioVenta: 100,
    stockActual: 30,
    unidadMedida: 'Unidad',
    tasaImpuesto: 15,
    estado: true,
  ),
  const Producto(
    idProducto: 2,
    idCategoria: 2,
    nombreProducto: 'Pan francés (docena)',
    codigoProducto: 'PAN-001',
    precioCompra: 50,
    precioVenta: 70,
    stockActual: 20,
    unidadMedida: 'Docena',
    tasaImpuesto: 0,
    estado: true,
  ),
  const Producto(
    idProducto: 3,
    idCategoria: 3,
    nombreProducto: 'Bebida gaseosa',
    codigoProducto: 'BEB-001',
    precioCompra: 18,
    precioVenta: 25,
    stockActual: 50,
    unidadMedida: 'Unidad',
    tasaImpuesto: 15,
    estado: true,
  ),
];

const List<String> _metodosPago = [
  'Efectivo',
  'Tarjeta',
  'Transferencia',
  'Cheque',
];

class _LineaVenta {
  Producto? producto;
  int cantidad;
  double descuento;

  // ignore: unused_element_parameter
  _LineaVenta({this.producto, this.cantidad = 1, this.descuento = 0});

  double get importeBruto => (producto?.precioVenta ?? 0) * cantidad;
  double get subtotal =>
      (importeBruto - descuento).clamp(0, double.infinity).toDouble();
  double get impuesto => subtotal * ((producto?.tasaImpuesto ?? 0) / 100);
  double get baseExenta => producto?.tasaImpuesto == 0 ? subtotal : 0;
  double get baseGravada => (producto?.tasaImpuesto ?? 0) > 0 ? subtotal : 0;
  double get isv15 => producto?.tasaImpuesto == 15 ? impuesto : 0;
  double get isv18 => producto?.tasaImpuesto == 18 ? impuesto : 0;
}

class FormularioVentaScreen extends StatefulWidget {
  const FormularioVentaScreen({super.key});

  @override
  State<FormularioVentaScreen> createState() => _FormularioVentaScreenState();
}

class _FormularioVentaScreenState extends State<FormularioVentaScreen> {
  final _formKey = GlobalKey<FormState>();
  // correspondiente para clientes exentos y exonerados.
  // final _ordenExentaController = TextEditingController();
  // final _constanciaExoneradosController = TextEditingController();
  // final _registroSagController = TextEditingController();

  Venta? _venta;
  Cliente? _clienteSeleccionado;
  String _metodoPago = _metodosPago.first;
  DateTime _fechaVenta = DateTime.now();
  List<_LineaVenta> _lineas = [_LineaVenta()];
  bool _argumentosCargados = false;

  bool get _soloLectura => _venta != null;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_argumentosCargados) return;
    _argumentosCargados = true;
    _venta = ModalRoute.of(context)?.settings.arguments as Venta?;

    final venta = _venta;
    if (venta == null) return;

    _metodoPago = venta.metodoPago ?? _metodosPago.first;
    _fechaVenta = venta.fechaVenta;

    _clienteSeleccionado = Cliente(
      idCliente: venta.idCliente,
      nombreCliente: venta.clienteNombreFactura,
      rtn: venta.clienteRtnFactura,
      direccion: venta.clienteDireccionFactura,
      telefono: venta.clienteTelefonoFactura,
      correo: venta.clienteCorreoFactura,
      fechaRegistro: venta.fechaVenta,
      estado: true,
    );

    _lineas = venta.detalles.map((detalle) {
      return _LineaVenta(
        producto: Producto(
          idProducto: detalle.idProducto,
          idCategoria: 0,
          nombreProducto: detalle.productoNombreFactura,
          descripcion: detalle.productoDescripcionFactura,
          codigoProducto: detalle.productoCodigoFactura,
          precioVenta: detalle.precioUnitario,
          stockActual: detalle.cantidad,
          unidadMedida: detalle.productoUnidadMedidaFactura,
          tasaImpuesto: detalle.productoTasaImpuestoFactura,
          estado: true,
        ),
        cantidad: detalle.cantidad,
        descuento: detalle.descuento,
      );
    }).toList();

    if (_lineas.isEmpty) _lineas = [_LineaVenta()];
  }

  @override
  void dispose() {
    // _ordenExentaController.dispose();
    // _constanciaExoneradosController.dispose();
    // _registroSagController.dispose();
    super.dispose();
  }

  double get _subtotal =>
      _lineas.fold(0, (total, linea) => total + linea.subtotal);
  double get _totalDescuentos =>
      _lineas.fold(0, (total, linea) => total + linea.descuento);
  double get _totalExento =>
      _lineas.fold(0, (total, linea) => total + linea.baseExenta);
  double get _totalGravado15 => _lineas
      .where((linea) => linea.producto?.tasaImpuesto == 15)
      .fold(0, (total, linea) => total + linea.baseGravada);
  double get _totalGravado18 => _lineas
      .where((linea) => linea.producto?.tasaImpuesto == 18)
      .fold(0, (total, linea) => total + linea.baseGravada);
  double get _totalIsv15 =>
      _lineas.fold(0, (total, linea) => total + linea.isv15);
  double get _totalIsv18 =>
      _lineas.fold(0, (total, linea) => total + linea.isv18);
  double get _total => _subtotal + _totalIsv15 + _totalIsv18;

  String _lps(double valor) => 'L. ${valor.toStringAsFixed(2)}';

  String _fecha(DateTime fecha) {
    final dia = fecha.day.toString().padLeft(2, '0');
    final mes = fecha.month.toString().padLeft(2, '0');
    return '$dia/$mes/${fecha.year}';
  }

  Future<void> _seleccionarFecha() async {
    final fecha = await showDatePicker(
      context: context,
      initialDate: _fechaVenta,
      firstDate: DateTime(2026, 7, 12),
      lastDate: DateTime(2027, 7, 12),
    );
    if (fecha != null) setState(() => _fechaVenta = fecha);
  }

  void _agregarLinea() => setState(() => _lineas.add(_LineaVenta()));

  void _eliminarLinea(int index) {
    if (_lineas.length == 1) return;
    setState(() => _lineas.removeAt(index));
  }

  void _registrarVenta() {
    if (!_formKey.currentState!.validate() || _clienteSeleccionado == null) {
      _mensaje('Completa los datos obligatorios de la venta');
      return;
    }
    if (_lineas.any((linea) => linea.producto == null)) {
      _mensaje('Selecciona un producto en cada línea');
      return;
    }

    const correlativo = 1;
    const numeroFactura = '000-001-01-00000001';
    final cliente = _clienteSeleccionado!;

    final detalles = _lineas.map((linea) {
      final producto = linea.producto!;
      return DetalleVenta(
        idVenta: 0,
        idProducto: producto.idProducto ?? 0,
        productoCodigoFactura: producto.codigoProducto,
        productoNombreFactura: producto.nombreProducto,
        productoDescripcionFactura: producto.descripcion,
        productoUnidadMedidaFactura: producto.unidadMedida,
        productoTasaImpuestoFactura: producto.tasaImpuesto,
        cantidad: linea.cantidad,
        precioUnitario: producto.precioVenta,
        descuento: linea.descuento,
        subtotal: linea.subtotal,
        baseGravada: linea.baseGravada,
        baseExenta: linea.baseExenta,
        montoImpuesto: linea.impuesto,
      );
    }).toList();

    final nuevaVenta = Venta(
      idCliente: cliente.idCliente,
      idUsuario: 1,
      usuarioNombreFactura: 'Administrador',
      idAutorizacion: 1,
      numeroFactura: numeroFactura,
      correlativo: correlativo,
      caiFactura: '3C18C3-8C69E3-1BE5E0-63BE03-0909BF-A0',
      rangoInicialFactura: '000-001-01-00000001',
      rangoFinalFactura: '000-001-01-00005000',
      fechaLimiteEmisionFactura: DateTime(2027, 7, 12),
      empresaNombreFactura: 'Inversiones Sammy',
      empresaRazonSocialFactura: 'Inversiones Sammy',
      empresaRtnFactura: '01079016892580',
      empresaDireccionFactura:
          'Los Fuertes contiguo al Super Olguita, Roatan, Islas de la Bahia',
      empresaTelefonoFactura: '97547973',
      empresaCorreoFactura: 'inversionesammy2019@hotmail.com',
      clienteNombreFactura: cliente.nombreCliente,
      clienteRtnFactura: cliente.rtn,
      clienteDireccionFactura: cliente.direccion,
      clienteTelefonoFactura: cliente.telefono,
      clienteCorreoFactura: cliente.correo,
      // Se mantienen nulos hasta implementar la validación de exoneraciones.
      ordenCompraExenta: null,
      constanciaRegistroExonerados: null,
      registroSag: null,
      fechaVenta: _fechaVenta,
      subtotal: _subtotal,
      totalDescuentos: _totalDescuentos,
      totalExento: _totalExento,
      totalGravado15: _totalGravado15,
      totalGravado18: _totalGravado18,
      totalIsv15: _totalIsv15,
      totalIsv18: _totalIsv18,
      total: _total,
      totalLetras: '${_total.toStringAsFixed(2)} LEMPIRAS',
      metodoPago: _metodoPago,
      detalles: detalles,
    );

    Navigator.pop(context, nuevaVenta);
  }

  Future<void> _anularFactura() async {
    final venta = _venta;
    if (venta == null || !venta.estadoFactura) return;

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Anular factura'),
        content: Text(
          '¿Deseas anular la factura ${venta.numeroFactura}? Esta acción no permite editar sus datos.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: AppColors.white,
            ),
            child: const Text('Anular'),
          ),
        ],
      ),
    );

    if (!mounted || confirmar != true) return;
    Navigator.pop(context, _conEstado(venta, false));
  }

  Venta _conEstado(Venta venta, bool estado) {
    return Venta(
      idVenta: venta.idVenta,
      idCliente: venta.idCliente,
      idUsuario: venta.idUsuario,
      usuarioNombreFactura: venta.usuarioNombreFactura,
      idAutorizacion: venta.idAutorizacion,
      numeroFactura: venta.numeroFactura,
      correlativo: venta.correlativo,
      caiFactura: venta.caiFactura,
      rangoInicialFactura: venta.rangoInicialFactura,
      rangoFinalFactura: venta.rangoFinalFactura,
      fechaLimiteEmisionFactura: venta.fechaLimiteEmisionFactura,
      empresaNombreFactura: venta.empresaNombreFactura,
      empresaRazonSocialFactura: venta.empresaRazonSocialFactura,
      empresaRtnFactura: venta.empresaRtnFactura,
      empresaDireccionFactura: venta.empresaDireccionFactura,
      empresaTelefonoFactura: venta.empresaTelefonoFactura,
      empresaCorreoFactura: venta.empresaCorreoFactura,
      empresaLogoFactura: venta.empresaLogoFactura,
      clienteNombreFactura: venta.clienteNombreFactura,
      clienteRtnFactura: venta.clienteRtnFactura,
      clienteDireccionFactura: venta.clienteDireccionFactura,
      clienteTelefonoFactura: venta.clienteTelefonoFactura,
      clienteCorreoFactura: venta.clienteCorreoFactura,
      ordenCompraExenta: venta.ordenCompraExenta,
      constanciaRegistroExonerados: venta.constanciaRegistroExonerados,
      registroSag: venta.registroSag,
      fechaVenta: venta.fechaVenta,
      subtotal: venta.subtotal,
      totalDescuentos: venta.totalDescuentos,
      totalExento: venta.totalExento,
      totalExonerado: venta.totalExonerado,
      totalGravado15: venta.totalGravado15,
      totalGravado18: venta.totalGravado18,
      totalIsv15: venta.totalIsv15,
      totalIsv18: venta.totalIsv18,
      total: venta.total,
      totalLetras: venta.totalLetras,
      estadoFactura: estado,
      metodoPago: venta.metodoPago,
      detalles: venta.detalles,
    );
  }

  void _mensaje(String texto) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(texto), backgroundColor: AppColors.error),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          _soloLectura ? 'Datos de la factura' : 'Nueva venta',
          style: AppTextStyles.screenTitle,
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
      ),
      body: _buildFormulario(),
      bottomNavigationBar: _buildAccionInferior(),
    );
  }

  Widget _buildFormulario() {
    final venta = _venta;
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          if (venta != null) ...[
            _estadoFactura(venta),
            const SizedBox(height: 16),
          ],
          _card(
            titulo: 'Datos de la venta',
            children: [
              DropdownButtonFormField<Cliente>(
                initialValue: _clienteSeleccionado,
                isExpanded: true,
                decoration: const InputDecoration(
                  labelText: 'Cliente',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                items:
                    (_soloLectura
                            ? [_clienteSeleccionado!]
                            : _clientes
                                  .where((cliente) => cliente.estado)
                                  .toList())
                        .map(
                          (cliente) => DropdownMenuItem(
                            value: cliente,
                            child: Text(
                              cliente.nombreCliente,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        )
                        .toList(),
                onChanged: _soloLectura
                    ? null
                    : (cliente) =>
                          setState(() => _clienteSeleccionado = cliente),
                validator: (cliente) =>
                    cliente == null ? 'Selecciona un cliente' : null,
              ),
              const SizedBox(height: 14),
              _campoBloqueado(
                'Número de factura',
                venta?.numeroFactura ?? '000-001-01-00000001',
              ),
              const SizedBox(height: 14),
              InkWell(
                onTap: _soloLectura ? null : _seleccionarFecha,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Fecha de venta',
                    prefixIcon: Icon(Icons.calendar_today_outlined),
                  ),
                  child: Text(_fecha(_fechaVenta)),
                ),
              ),
              const SizedBox(height: 14),
              DropdownButtonFormField<String>(
                initialValue: _metodoPago,
                decoration: const InputDecoration(
                  labelText: 'Método de pago',
                  prefixIcon: Icon(Icons.payments_outlined),
                ),
                items: _metodosPago
                    .map(
                      (metodo) =>
                          DropdownMenuItem(value: metodo, child: Text(metodo)),
                    )
                    .toList(),
                onChanged: _soloLectura
                    ? null
                    : (metodo) => setState(() => _metodoPago = metodo!),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _card(
            titulo: 'Datos fiscales',
            children: [
              _campoBloqueado(
                'CAI',
                venta?.caiFactura ?? '3C18C3-8C69E3-1BE5E0-63BE03-0909BF-A0',
              ),
              const SizedBox(height: 12),
              _campoBloqueado(
                'Rango autorizado',
                venta == null
                    ? '000-001-01-00000001 al 000-001-01-00005000'
                    : '${venta.rangoInicialFactura} al ${venta.rangoFinalFactura}',
              ),
              const SizedBox(height: 12),
              _campoBloqueado(
                'Fecha límite de emisión',
                venta == null
                    ? '12/07/2027'
                    : _fecha(venta.fechaLimiteEmisionFactura),
              ),
              // Los siguientes campos se habilitarán cuando exista una
              // validación para ventas exentas o exoneradas:
              // const SizedBox(height: 12),
              // TextFormField(label: 'Orden de compra exenta'),
              // TextFormField(label: 'Constancia de registro de exonerados'),
              // TextFormField(label: 'Registro SAG'),
            ],
          ),
          const SizedBox(height: 16),
          _buildProductosEditables(),
          const SizedBox(height: 16),
          venta == null ? _buildResumenNuevo() : _buildResumenLectura(venta),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildProductosEditables() {
    return _card(
      titulo: 'Productos',
      accion: _soloLectura
          ? null
          : TextButton.icon(
              onPressed: _agregarLinea,
              icon: const Icon(Icons.add),
              label: const Text('Agregar'),
            ),
      children: [
        for (int index = 0; index < _lineas.length; index++) ...[
          _lineaEditable(index),
          if (index != _lineas.length - 1) const Divider(height: 28),
        ],
      ],
    );
  }

  Widget _lineaEditable(int index) {
    final linea = _lineas[index];
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<Producto>(
                initialValue: linea.producto,
                isExpanded: true,
                decoration: const InputDecoration(labelText: 'Producto'),
                items:
                    (_soloLectura
                            ? <Producto>[
                                if (linea.producto != null) linea.producto!,
                              ]
                            : _productos
                                  .where((producto) => producto.estado)
                                  .toList())
                        .map(
                          (producto) => DropdownMenuItem(
                            value: producto,
                            child: Text(
                              '${producto.nombreProducto} · ${_lps(producto.precioVenta)}',
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        )
                        .toList(),
                onChanged: _soloLectura
                    ? null
                    : (producto) => setState(() => linea.producto = producto),
                validator: (producto) =>
                    producto == null ? 'Selecciona un producto' : null,
              ),
            ),
            if (!_soloLectura)
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
            const Text('Cantidad'),
            IconButton(
              onPressed: !_soloLectura && linea.cantidad > 1
                  ? () => setState(() => linea.cantidad--)
                  : null,
              icon: const Icon(Icons.remove_circle_outline),
            ),
            Text('${linea.cantidad}', style: AppTextStyles.cardTitle),
            IconButton(
              onPressed: _soloLectura
                  ? null
                  : () => setState(() => linea.cantidad++),
              icon: const Icon(Icons.add_circle_outline),
            ),
            const Spacer(),
            Text(_lps(linea.subtotal), style: AppTextStyles.price),
          ],
        ),
      ],
    );
  }

  Widget _buildResumenNuevo() {
    return _card(
      titulo: 'Resumen',
      children: [
        _filaTotal('Subtotal', _subtotal),
        _filaTotal('Descuentos', _totalDescuentos),
        _filaTotal('Exento', _totalExento),
        _filaTotal('Gravado 15%', _totalGravado15),
        _filaTotal('Gravado 18%', _totalGravado18),
        _filaTotal('ISV 15%', _totalIsv15),
        _filaTotal('ISV 18%', _totalIsv18),
        const Divider(height: 24),
        _filaTotal('Total', _total, destacar: true),
      ],
    );
  }

  Widget _buildResumenLectura(Venta venta) {
    return _card(
      titulo: 'Resumen',
      children: [
        _filaTotal('Subtotal', venta.subtotal),
        _filaTotal('Descuentos', venta.totalDescuentos),
        _filaTotal('Exento', venta.totalExento),
        _filaTotal('Exonerado', venta.totalExonerado),
        _filaTotal('Gravado 15%', venta.totalGravado15),
        _filaTotal('Gravado 18%', venta.totalGravado18),
        _filaTotal('ISV 15%', venta.totalIsv15),
        _filaTotal('ISV 18%', venta.totalIsv18),
        const Divider(height: 24),
        _filaTotal('Total', venta.total, destacar: true),
        const SizedBox(height: 8),
        Text(venta.totalLetras, style: AppTextStyles.subtitle),
      ],
    );
  }

  Widget _estadoFactura(Venta venta) {
    final color = venta.estadoFactura ? AppColors.success : AppColors.error;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(
            venta.estadoFactura ? Icons.check_circle_outline : Icons.block,
            color: color,
          ),
          const SizedBox(width: 10),
          Text(
            venta.estadoFactura ? 'Factura emitida' : 'Factura anulada',
            style: TextStyle(color: color, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }

  Widget _buildAccionInferior() {
    final venta = _venta;
    final anulada = venta != null && !venta.estadoFactura;
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      color: AppColors.white,
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 50,
          child: ElevatedButton.icon(
            onPressed: _soloLectura
                ? (anulada ? null : _anularFactura)
                : _registrarVenta,
            icon: Icon(_soloLectura ? Icons.block : Icons.point_of_sale),
            label: Text(
              _soloLectura
                  ? (anulada ? 'Factura anulada' : 'Anular factura')
                  : 'Registrar venta',
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: _soloLectura
                  ? AppColors.error
                  : AppColors.primary,
              foregroundColor: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _card({
    required String titulo,
    required List<Widget> children,
    Widget? accion,
  }) {
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
              children: [
                Expanded(
                  child: Text(titulo, style: AppTextStyles.sectionTitle),
                ),
                ?accion,
              ],
            ),
            const SizedBox(height: 14),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _campoBloqueado(String etiqueta, String valor) {
    return TextFormField(
      initialValue: valor,
      enabled: false,
      decoration: InputDecoration(labelText: etiqueta),
    );
  }

  Widget _filaTotal(String etiqueta, double valor, {bool destacar = false}) {
    final estilo = destacar ? AppTextStyles.cardTitle : AppTextStyles.subtitle;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(etiqueta, style: estilo),
          Text(_lps(valor), style: estilo),
        ],
      ),
    );
  }
}
