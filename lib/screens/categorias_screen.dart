import 'package:flutter/material.dart';
import '../config/app_text_styles.dart';
import '../config/app_colors.dart';
import '../models/categoria_model.dart';
import '../widgets/categoria_card.dart';

class CategoriasScreen extends StatefulWidget {
  const CategoriasScreen({super.key});

  @override
  State<CategoriasScreen> createState() => _CategoriasScreenState();
}

class _CategoriasScreenState extends State<CategoriasScreen> {
  final List<Categoria> categorias = [
    Categoria(
      idCategoria: 1,
      nombreCategoria: "Lácteos",
      descripcion: "Leche, quesos, yogurt y derivados",
      estado: true,
    ),
    Categoria(
      idCategoria: 2,
      nombreCategoria: "Cereales",
      descripcion: "Arroz, avena, granos y harinas",
      estado: true,
    ),
    Categoria(
      idCategoria: 3,
      nombreCategoria: "Proteínas",
      descripcion: "Huevos, carnes y embutidos",
      estado: true,
    ),
    Categoria(
      idCategoria: 4,
      nombreCategoria: "Bebidas",
      descripcion: "Jugos, gaseosas y bebidas alcohólicas",
      estado: false,
    ),
    Categoria(
      idCategoria: 5,
      nombreCategoria: "Postres",
      descripcion: "Galletas, dulces y repostería",
      estado: true,
    ),
  ];

  final Set<int> categoriasFavoritas = {};

  void _abrirFormularioEdicion(BuildContext context, Categoria categoria) {
    Navigator.pushNamed(context, '/formulario_categoria', arguments: categoria);
  }

  void _eliminarCategoria(Categoria categoria) {
    setState(() {
      categorias.remove(categoria);
      categoriasFavoritas.remove(categoria.idCategoria);
    });
  }

  void _cambiarFavorito(Categoria categoria) {
    final id = categoria.idCategoria;

    setState(() {
      if (categoriasFavoritas.contains(id)) {
        categoriasFavoritas.remove(id);
      } else {
        categoriasFavoritas.add(id);
      }
    });
  }

  void _mostrarFormularioCategoria(BuildContext context) {
    final nombreController = TextEditingController();
    final descripcionController = TextEditingController();

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
                    controller: nombreController,
                    decoration: const InputDecoration(
                      labelText: "Nombre",
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 15),

                  TextField(
                    controller: descripcionController,
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
                        if (nombreController.text.trim().isEmpty) {
                          return;
                        }

                        final nuevaCategoria = Categoria(
                          idCategoria: categorias.length + 1,
                          nombreCategoria: nombreController.text.trim(),
                          descripcion: descripcionController.text.trim(),
                          estado: estado,
                        );

                        setState(() {
                          categorias.add(nuevaCategoria);
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
      ),

      backgroundColor: AppColors.background,

      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 10),
        itemCount: categorias.length,
        itemBuilder: (context, index) {
          final categoria = categorias[index];

          final esFavorita = categoriasFavoritas.contains(
            categoria.idCategoria,
          );

          return Dismissible(
            key: ValueKey(categoria.idCategoria),

            direction: DismissDirection.horizontal,

            // Deslizar hacia la derecha -> Editar
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

            // Deslizar hacia la izquierda -> Eliminar
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
              // Deslizar hacia la derecha
              if (direction == DismissDirection.startToEnd) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Editando ${categoria.nombreCategoria}"),
                  ),
                );

                _abrirFormularioEdicion(context, categoria);

                // No desaparece el item
                return false;
              }

              // Deslizar hacia la izquierda
              if (direction == DismissDirection.endToStart) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("${categoria.nombreCategoria} eliminada"),
                  ),
                );

                // Permitir que desaparezca
                return true;
              }

              return false;
            },

            onDismissed: (direction) {
              if (direction == DismissDirection.endToStart) {
                _eliminarCategoria(categoria);
              }
            },

            child: _CategoriaItem(
              categoria: categoria,
              esFavorita: esFavorita,

              onTap: () {
                _abrirFormularioEdicion(context, categoria);
              },

              onEliminar: () {
                _eliminarCategoria(categoria);
              },

              onFavorito: () {
                _cambiarFavorito(categoria);
              },
            ),
          );
        },
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _mostrarFormularioCategoria(context);

          // Antes se enviaba a otra pantalla:
          // Navigator.pushNamed(
          //   context,
          //   '/formulario_categoria',
          // );
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
  final bool esFavorita;
  final VoidCallback onTap;
  final VoidCallback onEliminar;
  final VoidCallback onFavorito;

  const _CategoriaItem({
    required this.categoria,
    required this.esFavorita,
    required this.onTap,
    required this.onEliminar,
    required this.onFavorito,
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
                "\"${categoria.nombreCategoria}\"?",
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
                        content: Text("${categoria.nombreCategoria} eliminada"),
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
            nombre: categoria.nombreCategoria,
            descripcion: categoria.descripcion ?? "",
            activo: categoria.estado,
          ),

          Positioned(
            right: 8,
            top: 8,
            child: IconButton(
              onPressed: onFavorito,
              icon: Icon(
                esFavorita ? Icons.favorite : Icons.favorite_border,
                color: esFavorita ? Colors.red : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
