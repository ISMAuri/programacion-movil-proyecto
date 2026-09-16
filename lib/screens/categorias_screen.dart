import 'package:flutter/material.dart';

import '../config/app_text_styles.dart';
import '../config/app_colors.dart';
import '../models/categoria.dart';
import '../widgets/categoria_card.dart';
import '../services/categoria_service.dart';

import '../services/auth_service.dart';

class CategoriasScreen extends StatefulWidget {
  const CategoriasScreen({super.key});

  @override
  State<CategoriasScreen> createState() => _CategoriasScreenState();
}

class _CategoriasScreenState extends State<CategoriasScreen> {
  final CategoriaService _categoriaService = CategoriaService();

  final AuthService _authService = AuthService();

  List<Categoria> categorias = [];

  final _nombreController = TextEditingController();
  final _descripcionController = TextEditingController();

  String _busqueda = '';

  bool cargando = true;
  bool esAdmin = false;

  @override
  void initState() {
    super.initState();
    _cargarUsuario();
    _cargarCategorias();
  }

  Future<void> _cargarUsuario() async {
    try {
      final usuario = await _authService.getCurrentUser();

      if (!mounted) return;

      setState(() {
        esAdmin = usuario.role.trim().toLowerCase() == 'admin';
      });
    } catch (e) {
      debugPrint('Error al cargar rol del usuario: $e');
    }
  }

  Future<void> _cargarCategorias() async {
    setState(() => cargando = true);

    try {
      final response = await _categoriaService.getCategorias(
        soloActivas: false,
      );

      if (!mounted) return;

      setState(() {
        categorias = response;
        cargando = false;
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Error al cargar categorías"),
          backgroundColor: AppColors.error,
        ),
      );

      setState(() => cargando = false);
    }
  }

  List<Categoria> get _categoriasFiltradas {
    final texto = _busqueda.toLowerCase().trim();

    if (texto.isEmpty) {
      return categorias;
    }

    return categorias.where((categoria) {
      return categoria.nombre.toLowerCase().contains(texto) ||
          (categoria.descripcion?.toLowerCase().contains(texto) ?? false);
    }).toList();
  }

  // Obtiene el icono correspondiente a cada categoría.
  // Si no encuentra una categoría conocida,
  // utiliza un icono por defecto.
  IconData _obtenerIcono(Categoria categoria) {
    switch (categoria.nombre.toLowerCase()) {
      case 'abarrotes':
        return Icons.shopping_basket_outlined;

      case 'bebidas':
        return Icons.local_drink_outlined;

      case 'limpieza':
        return Icons.cleaning_services_outlined;

      case 'higiene personal':
        return Icons.sanitizer_outlined;

      case 'papel y desechables':
        return Icons.inventory_2_outlined;

      case 'snacks y confitería':
        return Icons.cookie_outlined;

      case 'papelería':
        return Icons.edit_note_outlined;

      case 'ferretería y mantenimiento':
        return Icons.handyman_outlined;

      default:
        return Icons.inventory_2_outlined;
    }
  }

  Future<void> guardarCategoria() async {
    final categoria = Categoria(
      nombre: _nombreController.text.trim(),
      descripcion: _descripcionController.text.trim(),
      icono: null,
    );

    try {
      await _categoriaService.postCategoria(categoria);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Categoría creada correctamente'),
          backgroundColor: AppColors.success,
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Error al crear categoría'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  void _abrirFormularioEdicion(BuildContext context, Categoria categoria) {
    Navigator.pushNamed(context, '/formulario_categoria', arguments: categoria);
  }

  Future<void> _eliminarCategoria(Categoria categoria) async {
    try {
      final categoriaInactiva = Categoria(
        id: categoria.id,
        nombre: categoria.nombre,
        descripcion: categoria.descripcion,
        icono: categoria.icono,
        activo: false,
      );

      await _categoriaService.putCategoria(categoria.id!, categoriaInactiva);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Error al desactivar la categoría'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  void _mostrarFormularioCategoria(BuildContext context) {
    bool estado = true;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateBottomSheet) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Nueva categoría",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 20),

                  TextField(
                    controller: _nombreController,
                    decoration: const InputDecoration(
                      labelText: "Nombre",
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 15),

                  TextField(
                    controller: _descripcionController,
                    decoration: const InputDecoration(
                      labelText: "Descripción",
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 15),

                  DropdownButtonFormField<bool>(
                    initialValue: estado,
                    decoration: const InputDecoration(
                      labelText: "Estado",
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: true, child: Text("Activa")),
                      DropdownMenuItem(value: false, child: Text("Inactiva")),
                    ],
                    onChanged: (value) {
                      setStateBottomSheet(() {
                        estado = value ?? true;
                      });
                    },
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
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
                              SnackBar(
                                content: Text(mensaje),
                                backgroundColor: AppColors.error,
                              ),
                            );

                          return;
                        }

                        if (nombre.length < 3) {
                          ScaffoldMessenger.of(context)
                            ..hideCurrentSnackBar()
                            ..showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "El nombre debe tener al menos 3 caracteres",
                                ),
                                backgroundColor: AppColors.error,
                              ),
                            );

                          return;
                        }

                        if (descripcion.length < 5) {
                          ScaffoldMessenger.of(context)
                            ..hideCurrentSnackBar()
                            ..showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "La descripción debe tener al menos 5 caracteres",
                                ),
                                backgroundColor: AppColors.error,
                              ),
                            );

                          return;
                        }

                        final nuevaCategoria = Categoria(
                          nombre: nombre,
                          descripcion: descripcion,
                          activo: estado,
                        );

                        try {
                          final categoriaCreada = await _categoriaService
                              .postCategoria(nuevaCategoria);

                          if (!mounted) return;

                          setState(() {
                            categorias.add(categoriaCreada);
                          });

                          if (!context.mounted) return;

                          Navigator.pop(context);

                          ScaffoldMessenger.of(this.context)
                            ..hideCurrentSnackBar()
                            ..showSnackBar(
                              const SnackBar(
                                content: Text("Categoría creada correctamente"),
                                backgroundColor: AppColors.success,
                              ),
                            );
                        } catch (e) {
                          if (!context.mounted) return;

                          ScaffoldMessenger.of(context)
                            ..hideCurrentSnackBar()
                            ..showSnackBar(
                              const SnackBar(
                                content: Text("Error al crear la categoría"),
                                backgroundColor: AppColors.error,
                              ),
                            );
                        }
                      },
                      child: const Text("Guardar"),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final categoriasFiltradas = _categoriasFiltradas;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Categorías", style: AppTextStyles.screenTitle),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        actions: [
          IconButton(
            onPressed: _cargarCategorias,
            icon: const Icon(Icons.refresh),
            tooltip: 'Actualizar categorias',
          ),
        ],
      ),
      backgroundColor: AppColors.background,
      body: cargando
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  child: Container(
                    height: 46,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: TextField(
                      onChanged: (valor) {
                        setState(() {
                          _busqueda = valor;
                        });
                      },
                      decoration: const InputDecoration(
                        hintText: 'Buscar por nombre o descripción...',
                        prefixIcon: Icon(Icons.search),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),

                Expanded(
                  child: categoriasFiltradas.isEmpty
                      ? const Center(
                          child: Text('No se encontraron categorías'),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          itemCount: categoriasFiltradas.length,
                          itemBuilder: (context, index) {
                            final categoria = categoriasFiltradas[index];

                            return Dismissible(
                              key: ValueKey(categoria.id),
                              // Permitir deslizar solo si el usuario es admin
                              direction: esAdmin
                                  ? DismissDirection.horizontal
                                  : DismissDirection.none,

                              // Deslizar hacia la derecha = Editar
                              background: Container(
                                color: Colors.green,
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                child: const Row(
                                  children: [
                                    Icon(Icons.edit, color: Colors.white),
                                    SizedBox(width: 8),
                                    Text(
                                      "Editar",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Deslizar hacia la izquierda = Eliminar
                              secondaryBackground: Container(
                                color: Colors.red,
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      "Eliminar",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Icon(Icons.delete, color: Colors.white),
                                  ],
                                ),
                              ),

                              confirmDismiss: (direction) async {
                                if (!esAdmin) {
                                  return false;
                                }

                                if (direction == DismissDirection.startToEnd) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        "Editando ${categoria.nombre}",
                                      ),
                                    ),
                                  );

                                  _abrirFormularioEdicion(context, categoria);

                                  return false;
                                }

                                if (direction == DismissDirection.endToStart) {
                                  try {
                                    await _eliminarCategoria(categoria);

                                    WidgetsBinding.instance.addPostFrameCallback((
                                      _,
                                    ) {
                                      if (!mounted) return;

                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            '${categoria.nombre} marcada como inactiva',
                                          ),
                                          backgroundColor: AppColors.success,
                                        ),
                                      );

                                      _cargarCategorias();
                                    });

                                    return false;
                                  } catch (e) {
                                    if (!context.mounted) {
                                      return false;
                                    }

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: const Text(
                                          'Error al desactivar la categoría',
                                        ),
                                        backgroundColor: AppColors.error,
                                      ),
                                    );

                                    return false;
                                  }
                                }

                                return false;
                              },

                              child: _CategoriaItem(
                                categoria: categoria,
                                icono: _obtenerIcono(categoria),
                                esAdmin: esAdmin,
                                onTap: () {
                                  _abrirFormularioEdicion(context, categoria);
                                },
                                onEliminar: () {
                                  _eliminarCategoria(categoria);
                                },
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
      floatingActionButton: esAdmin
          ? FloatingActionButton.extended(
              onPressed: () {
                _mostrarFormularioCategoria(context);
              },
              backgroundColor: AppColors.secondary,
              foregroundColor: AppColors.white,
              icon: const Icon(Icons.add),
              label: const Text("Nueva categoría"),
            )
          : null,
    );
  }
}

class _CategoriaItem extends StatelessWidget {
  final Categoria categoria;
  final bool esAdmin;
  final IconData icono;
  final VoidCallback onTap;
  final VoidCallback onEliminar;

  const _CategoriaItem({
    required this.categoria,
    required this.icono,
    required this.esAdmin,
    required this.onTap,
    required this.onEliminar,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,

      // Tocar normalmente -> abrir categoría
      onTap: onTap,

      // Solo el administrador puede desactivar
      onLongPress: esAdmin
          ? () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text("Eliminar categoría"),
                    content: Text(
                      '¿Estás seguro de que deseas eliminar '
                      '"${categoria.nombre}"?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Cancelar"),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);

                          onEliminar();

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("${categoria.nombre} eliminada"),
                              backgroundColor: AppColors.error,
                            ),
                          );
                        },
                        child: const Text("Eliminar"),
                      ),
                    ],
                  );
                },
              );
            }
          : null,

      child: Stack(
        children: [
          CategoriaCard(
            nombre: categoria.nombre,
            descripcion: categoria.descripcion ?? "",
            activo: categoria.activo,
            icono: icono,
          ),
        ],
      ),
    );
  }
}
