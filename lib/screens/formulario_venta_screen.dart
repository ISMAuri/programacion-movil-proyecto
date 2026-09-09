import 'package:flutter/material.dart';

import '../config/app_colors.dart';
import '../config/app_text_styles.dart';

import '../models/autorizacion_factura.dart';
import '../models/cliente.dart';
import '../models/crear_venta_request.dart';
import '../models/detalle_venta.dart';
import '../models/detalle_venta_request.dart';
import '../models/producto.dart';
import '../models/venta.dart';

import '../services/auth_service.dart';
import '../services/autorizacion_factura_service.dart';
import '../services/cliente_service.dart';
import '../services/detalle_venta_service.dart';
import '../services/producto_service.dart';
import '../services/venta_service.dart';
import '../services/notification_service.dart';

import '../widgets/aviso_card.dart';

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

  _LineaVenta({this.producto, this.cantidad = 1, this.descuento = 0});

  double get importeBruto => (producto?.precioVenta ?? 0) * cantidad;

  double get subtotal =>
      (importeBruto - descuento).clamp(0, double.infinity).toDouble();

  double get impuesto => subtotal * ((producto?.tasaImpuesto ?? 0) / 100);

  double get baseTasaCero => producto?.tasaImpuesto == 0 ? subtotal : 0;

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

  final ClienteService _clienteService = ClienteService();
  final ProductoService _productoService = ProductoService();
  final VentaService _ventaService = VentaService();
  final AuthService _authService = AuthService();
  final AutorizacionFacturaService _autorizacionFacturaService =
      AutorizacionFacturaService();
  final DetalleVentaService _detalleVentaService = DetalleVentaService();

  final int _idEmpresa = 1;

  Venta? _venta;
  AutorizacionFactura? _autorizacionActiva;

  Cliente? _clienteSeleccionado;
  int? _idUsuarioActual;

  List<Cliente> _clientes = [];
  List<Producto> _productos = [];
  List<DetalleVenta> _detallesLectura = [];
  final List<_LineaVenta> _lineas = [_LineaVenta()];

  String _metodoPago = _metodosPago.first;
  DateTime _fechaVenta = DateTime.now();

  bool cargando = true;
  bool guardando = false;
  bool _argumentosCargados = false;

  bool get _soloLectura => _venta != null;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_argumentosCargados) return;
    _argumentosCargados = true;

    _venta = ModalRoute.of(context)?.settings.arguments as Venta?;

    final venta = _venta;

    if (venta != null) {
      _metodoPago = venta.metodoPago ?? _metodosPago.first;
      _fechaVenta = venta.fechaVenta;
    }

    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    try {
      if (_soloLectura) {
        final venta = _venta!;

        final detalles = await _detalleVentaService.getDetallesPorVenta(
          venta.idVenta,
        );

        if (!mounted) return;

        setState(() {
          _detallesLectura = detalles;
          cargando = false;
        });

        return;
      }

      final clientes = await _clienteService.getClientes(soloActivos: true);

      final productos = await _productoService.getProductos(soloActivos: true);

      final usuario = await _authService.getCurrentUser();

      final autorizacion = await _autorizacionFacturaService
          .getAutorizacionActivaEmpresa(_idEmpresa);

      if (!mounted) return;

      setState(() {
        _clientes = clientes;
        _productos = productos
            .where((producto) => producto.estado && producto.stockActual > 0)
            .toList();

        _idUsuarioActual = usuario.id;
        _autorizacionActiva = autorizacion;

        cargando = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        cargando = false;
      });

      _mensaje('Error al cargar los datos de la venta: $e');
    }
  }

  double get _subtotal =>
      _lineas.fold(0, (total, linea) => total + linea.subtotal);

  double get _totalDescuentos =>
      _lineas.fold(0, (total, linea) => total + linea.descuento);

  double get _totalTasaCero =>
      _lineas.fold(0, (total, linea) => total + linea.baseTasaCero);

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

  String _formatearNumeroFactura(int correlativo) {
    final autorizacion = _autorizacionActiva;

    if (autorizacion == null) {
      return 'No disponible';
    }

    return '${autorizacion.establecimiento}-'
        '${autorizacion.puntoEmision}-'
        '${autorizacion.tipoDocumento}-'
        '${correlativo.toString().padLeft(8, '0')}';
  }

  String get _numeroFacturaMostrado {
    final venta = _venta;

    if (venta != null) {
      return venta.numeroFactura;
    }

    final autorizacion = _autorizacionActiva;

    if (autorizacion == null) {
      return 'No disponible';
    }

    return _formatearNumeroFactura(autorizacion.siguienteCorrelativo);
  }

  String get _rangoMostrado {
    final venta = _venta;

    if (venta != null) {
      return '${venta.rangoInicialFactura} al '
          '${venta.rangoFinalFactura}';
    }

    final autorizacion = _autorizacionActiva;

    if (autorizacion == null) {
      return 'No disponible';
    }

    return '${_formatearNumeroFactura(autorizacion.rangoInicial)} '
        'al '
        '${_formatearNumeroFactura(autorizacion.rangoFinal)}';
  }

  String get _caiMostrado {
    if (_venta != null) {
      return _venta!.caiFactura;
    }

    return _autorizacionActiva?.cai ?? 'No disponible';
  }

  String get _fechaLimiteMostrada {
    if (_venta != null) {
      return _fecha(_venta!.fechaLimiteEmisionFactura);
    }

    final autorizacion = _autorizacionActiva;

    if (autorizacion == null) {
      return 'No disponible';
    }

    return _fecha(autorizacion.fechaLimiteEmision);
  }

  void _agregarLinea() {
    setState(() {
      _lineas.add(_LineaVenta());
    });
  }

  void _eliminarLinea(int index) {
    if (_lineas.length == 1) return;

    setState(() {
      _lineas.removeAt(index);
    });
  }

  List<Producto> _productosDisponiblesParaLinea(int index) {
    final idsSeleccionados = _lineas
        .asMap()
        .entries
        .where(
          (entry) =>
              entry.key != index && entry.value.producto?.idProducto != null,
        )
        .map((entry) => entry.value.producto!.idProducto)
        .toSet();

    return _productos
        .where((producto) => !idsSeleccionados.contains(producto.idProducto))
        .toList();
  }

  Future<void> _registrarVenta() async {
    if (!_formKey.currentState!.validate() || _clienteSeleccionado == null) {
      _mensaje('Completa los datos obligatorios de la venta');
      return;
    }

    if (_lineas.any((linea) => linea.producto == null)) {
      _mensaje('Selecciona un producto en cada línea');
      return;
    }

    final idsProductos = _lineas
        .map((linea) => linea.producto!.idProducto)
        .toList();

    if (idsProductos.toSet().length != idsProductos.length) {
      _mensaje('No puedes agregar el mismo producto más de una vez');
      return;
    }

    if (_idUsuarioActual == null || _autorizacionActiva == null) {
      _mensaje('No se pudo obtener el usuario o la autorización fiscal activa');
      return;
    }

    for (final linea in _lineas) {
      final producto = linea.producto!;

      if (linea.cantidad > producto.stockActual) {
        _mensaje(
          'Stock insuficiente para '
          '${producto.nombreProducto}',
        );
        return;
      }
    }

    final request = CrearVentaRequest(
      idCliente: _clienteSeleccionado!.idCliente,
      idUsuario: _idUsuarioActual!,
      idAutorizacion: _autorizacionActiva!.idAutorizacion!,
      metodoPago: _metodoPago,
      ordenCompraExenta: null,
      constanciaRegistroExonerados: null,
      registroSag: null,
      detalles: _lineas.map((linea) {
        return DetalleVentaRequest(
          idProducto: linea.producto!.idProducto!,
          cantidad: linea.cantidad,
          descuento: linea.descuento,
        );
      }).toList(),
    );

    try {
      setState(() {
        guardando = true;
      });

      final ventaCreada = await _ventaService.postVenta(request);

      await NotificationService.mostrarNotificacion(
        titulo: 'Factura emitida',
        mensaje:
            'La factura ${ventaCreada.numeroFactura} fue registrada correctamente.',
      );

      if (!mounted) return;

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      setState(() {
        guardando = false;
      });

      _mensaje('Error al registrar la venta: $e');
    }
  }

  Future<void> _anularFactura() async {
    final venta = _venta;

    if (venta == null || !venta.estadoFactura) {
      return;
    }

    final diasTranscurridos = DateTime.now()
        .difference(venta.fechaVenta)
        .inDays;

    if (diasTranscurridos >= 30) {
      _mensaje(
        'La factura ya no puede anularse porque han pasado 30 días desde su emisión',
      );
      return;
    }

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Anular factura'),
        content: Text(
          '¿Deseas anular la factura '
          '${venta.numeroFactura}? '
          'Esta acción devolverá los productos al inventario.',
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

    if (!mounted || confirmar != true) {
      return;
    }

    try {
      setState(() {
        guardando = true;
      });

      final ventaAnulada = await _ventaService.anularVenta(venta.idVenta);

      await NotificationService.mostrarNotificacion(
        titulo: 'Factura anulada',
        mensaje:
            'La factura ${ventaAnulada.numeroFactura} fue anulada correctamente.',
      );

      if (!mounted) return;

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      setState(() {
        guardando = false;
      });

      _mensaje('Error al anular la factura: $e');
    }
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
      body: cargando
          ? const Center(child: CircularProgressIndicator())
          : _buildFormulario(),
      bottomNavigationBar: cargando ? null : _buildAccionInferior(),
    );
  }

  Widget _buildFormulario() {
    final venta = _venta;

    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          if (venta != null)
            AvisoCard(
              text:
                  'Si han pasado más de 30 días posteriores a la emisión de la factura, esta no podrá ser anulada.',
            ),
          const SizedBox(height: 16),
          if (venta != null) ...[
            _estadoFactura(venta),
            const SizedBox(height: 16),
          ],
          _card(
            titulo: 'Datos de la venta',
            children: [
              if (_soloLectura)
                _campoBloqueado(
                  'Cliente',
                  venta!.clienteNombreFactura,
                  icono: Icons.person_outline,
                )
              else
                DropdownButtonFormField<Cliente>(
                  initialValue: _clienteSeleccionado,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    labelText: 'Cliente',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  items: _clientes
                      .where((cliente) => cliente.estado)
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
                  onChanged: (cliente) {
                    setState(() {
                      _clienteSeleccionado = cliente;
                    });
                  },
                  validator: (cliente) =>
                      cliente == null ? 'Selecciona un cliente' : null,
                ),
              const SizedBox(height: 14),
              _campoBloqueado(
                'Número de factura',
                _numeroFacturaMostrado,
                icono: Icons.receipt_long_outlined,
              ),
              const SizedBox(height: 14),
              _campoBloqueado(
                'Fecha de venta',
                _fecha(_fechaVenta),
                icono: Icons.calendar_today_outlined,
              ),
              const SizedBox(height: 14),
              if (_soloLectura)
                _campoBloqueado(
                  'Método de pago',
                  venta!.metodoPago ?? 'No especificado',
                  icono: Icons.payments_outlined,
                )
              else
                DropdownButtonFormField<String>(
                  initialValue: _metodoPago,
                  decoration: const InputDecoration(
                    labelText: 'Método de pago',
                    prefixIcon: Icon(Icons.payments_outlined),
                  ),
                  items: _metodosPago
                      .map(
                        (metodo) => DropdownMenuItem(
                          value: metodo,
                          child: Text(metodo),
                        ),
                      )
                      .toList(),
                  onChanged: (metodo) {
                    if (metodo == null) return;

                    setState(() {
                      _metodoPago = metodo;
                    });
                  },
                ),
            ],
          ),
          const SizedBox(height: 16),
          _card(
            titulo: 'Datos fiscales',
            children: [
              _campoBloqueado('CAI', _caiMostrado),
              const SizedBox(height: 12),
              _campoBloqueado('Rango autorizado', _rangoMostrado),
              const SizedBox(height: 12),
              _campoBloqueado(
                'Fecha de autorización',
                _soloLectura
                    ? (_venta?.fechaAutorizacionFactura != null
                          ? _fecha(_venta!.fechaAutorizacionFactura)
                          : '')
                    : (_autorizacionActiva?.fechaAutorizacion != null
                          ? _fecha(_autorizacionActiva!.fechaAutorizacion)
                          : ''),
              ),
              const SizedBox(height: 12),
              _campoBloqueado('Fecha límite de emisión', _fechaLimiteMostrada),
              // Los siguientes campos se habilitarán
              // cuando se implemente la validación
              // de ventas exentas o exoneradas:
              //
              // Orden de compra exenta
              // Constancia de registro de exonerados
              // Registro SAG
            ],
          ),
          const SizedBox(height: 16),
          _soloLectura ? _buildDetallesLectura() : _buildProductosEditables(),
          const SizedBox(height: 16),
          _soloLectura ? _buildResumenLectura(venta!) : _buildResumenNuevo(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildProductosEditables() {
    return _card(
      titulo: 'Productos',
      accion: TextButton.icon(
        onPressed: _lineas.length < _productos.length ? _agregarLinea : null,
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
                items: _productosDisponiblesParaLinea(index)
                    .map(
                      (producto) => DropdownMenuItem(
                        value: producto,
                        child: Text(
                          '${producto.nombreProducto} · '
                          '${_lps(producto.precioVenta)}',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (producto) {
                  setState(() {
                    linea.producto = producto;
                    linea.cantidad = 1;
                  });
                },
                validator: (producto) =>
                    producto == null ? 'Selecciona un producto' : null,
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
            const Text('Cantidad'),
            IconButton(
              onPressed: linea.cantidad > 1
                  ? () {
                      setState(() {
                        linea.cantidad--;
                      });
                    }
                  : null,
              icon: const Icon(Icons.remove_circle_outline),
            ),
            Text('${linea.cantidad}', style: AppTextStyles.cardTitle),
            IconButton(
              onPressed:
                  linea.producto != null &&
                      linea.cantidad < linea.producto!.stockActual
                  ? () {
                      setState(() {
                        linea.cantidad++;
                      });
                    }
                  : null,
              icon: const Icon(Icons.add_circle_outline),
            ),
            const Spacer(),
            Text(_lps(linea.subtotal), style: AppTextStyles.price),
          ],
        ),
        if (linea.producto != null)
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Stock disponible: '
              '${linea.producto!.stockActual}',
              style: AppTextStyles.subtitle.copyWith(fontSize: 12),
            ),
          ),
      ],
    );
  }

  Widget _buildDetallesLectura() {
    return _card(
      titulo: 'Productos',
      children: [
        if (_detallesLectura.isEmpty)
          const Text('No hay detalles asociados a esta factura.')
        else
          for (int index = 0; index < _detallesLectura.length; index++) ...[
            _detalleLectura(_detallesLectura[index]),
            if (index != _detallesLectura.length - 1) const Divider(height: 28),
          ],
      ],
    );
  }

  Widget _detalleLectura(DetalleVenta detalle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(detalle.productoNombreFactura, style: AppTextStyles.cardTitle),
        const SizedBox(height: 8),
        _dato('Código', detalle.productoCodigoFactura),
        _dato('Unidad', detalle.productoUnidadMedidaFactura),
        _dato('Cantidad', detalle.cantidad.toString()),
        _dato('Precio unitario', _lps(detalle.precioUnitario)),
        _dato('Descuento', _lps(detalle.descuento)),
        _dato(
          'Tasa de impuesto',
          '${detalle.productoTasaImpuestoFactura.toStringAsFixed(2)}%',
        ),
        _dato('Monto de impuesto', _lps(detalle.montoImpuesto)),
        _dato('Subtotal', _lps(detalle.subtotal)),
      ],
    );
  }

  Widget _buildResumenNuevo() {
    return _card(
      titulo: 'Resumen',
      children: [
        _filaTotal('Subtotal', _subtotal),
        _filaTotal('Descuentos', _totalDescuentos),
        _filaTotal('Tasa 0%', _totalTasaCero),
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
        _filaTotal('Tasa 0%', venta.totalTasaCero),
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

    final fueraPlazo =
        venta != null &&
        DateTime.now().difference(venta.fechaVenta).inDays >= 30;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      color: AppColors.white,
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 50,
          child: ElevatedButton.icon(
            onPressed: guardando
                ? null
                : _soloLectura
                ? (anulada || fueraPlazo ? null : _anularFactura)
                : _registrarVenta,
            icon: Icon(_soloLectura ? Icons.block : Icons.point_of_sale),
            label: Text(
              guardando
                  ? 'Procesando...'
                  : _soloLectura
                  ? anulada
                        ? 'Factura anulada'
                        : fueraPlazo
                        ? 'Plazo de anulación vencido'
                        : 'Anular factura'
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
                if (accion != null) accion,
              ],
            ),
            const SizedBox(height: 14),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _campoBloqueado(String etiqueta, String valor, {IconData? icono}) {
    return TextFormField(
      initialValue: valor,
      enabled: false,
      decoration: InputDecoration(
        labelText: etiqueta,
        prefixIcon: icono == null ? null : Icon(icono),
      ),
    );
  }

  Widget _dato(String etiqueta, String? valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(etiqueta, style: AppTextStyles.subtitle),
          ),
          Expanded(
            child: Text(
              valor == null || valor.isEmpty ? 'N/A' : valor,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
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
