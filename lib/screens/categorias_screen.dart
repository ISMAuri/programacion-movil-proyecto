import 'package:flutter/material.dart';
import '../config/app_text_styles.dart';
import '../config/app_colors.dart';
import '../models/categoria.dart';
import '../widgets/categoria_card.dart';
import '../services/categoria_service.dart';

class CategoriasScreen extends StatefulWidget {
  const CategoriasScreen({super.key});

  @override
  State<CategoriasScreen> createState() => _CategoriasScreenState();
}

// Lista de categorías de ejemplo
class _CategoriasScreenState extends State<CategoriasScreen> {
  final CategoriaService _categoriaService = CategoriaService();

  List<Categoria> categorias = [];

  final _nombreController = TextEditingController();
  final _descripcionController = TextEditingController();

  bool cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarCategorias();
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
          content: Text("Error al cargar categorías"),
          backgroundColor: AppColors.error,
        ),
      );

      setState(() => cargando = false);
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
          content: Text('Error al crear categoría'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  // acciones sobre las categorías
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

  // formulario enbottomsheet para agregar una nueva categoria
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
                      onPressed: () {
                        if (_nombreController.text.trim().isEmpty) {
                          return;
                        }

                        final nuevaCategoria = Categoria(
                          nombre: _nombreController.text.trim(),
                          descripcion: _descripcionController.text.trim(),
                          activo: estado,
                        );

                        setState(() {
                          _categoriaService.postCategoria(nuevaCategoria).then((
                            categoriaCreada,
                          ) {
                            categorias.add(categoriaCreada);
                          });
                        });

                        Navigator.pop(context);
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
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 10),
              itemCount: categorias.length,
              itemBuilder: (context, index) {
                final categoria = categorias[index];

                return Dismissible(
                  key: ValueKey(categoria.id),

                  direction: DismissDirection.horizontal,
                  // si desliza hacia la derecha -> Editar
                  background: Container(
                    color: Colors.green,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
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

                  // si desliza hacia la izquierda -> Eliminar
                  secondaryBackground: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
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
                    // si desliza hacia la derecha
                    if (direction == DismissDirection.startToEnd) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Editando ${categoria.nombre}")),
                      );

                      _abrirFormularioEdicion(context, categoria);

                      // No desaparece el item
                      return false;
                    }

                    // si desliza hacia la izquierda
                    if (direction == DismissDirection.endToStart) {
                      try {
                        await _eliminarCategoria(categoria);

                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (!mounted) return;

                          ScaffoldMessenger.of(context).showSnackBar(
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
                        if (!context.mounted) return false;

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

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _mostrarFormularioCategoria(context);
        },
        backgroundColor: AppColors.secondary,
        foregroundColor: AppColors.white,
        icon: const Icon(Icons.add),
        label: const Text("Nueva categoría"),
      ),
    );
  }
}

// Widget reutilizable para cada categoría
class _CategoriaItem extends StatelessWidget {
  final Categoria categoria;
  final VoidCallback onTap;
  final VoidCallback onEliminar;

  const _CategoriaItem({
    required this.categoria,
    required this.onTap,
    required this.onEliminar,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,

      // Tocar normalmente -> editar
      onTap: onTap,

      // Mantener presionado -> eliminar
      onLongPress: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Eliminar categoría"),
              content: Text(
                "¿Estás seguro de que deseas eliminar "
                "\"${categoria.nombre}\"?",
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
      },

      child: Stack(
        children: [
          CategoriaCard(
            nombre: categoria.nombre,
            descripcion: categoria.descripcion ?? "",
            activo: categoria.activo,
          ),
        ],
      ),
    );
  }
}
