import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../config/app_text_styles.dart';

class SearchBarWidget extends StatelessWidget {
  // final Color color;
  // final Widget child;

  const SearchBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Buscar productos...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            onChanged: (value) {
              // Acción a realizar cuando se cambia el texto de búsqueda
            },
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount:
                10, // Número de productos (puedes cambiarlo según tus necesidades)
            itemBuilder: (context, index) {
              return ListTile(
                title: Text('Producto ${index + 1}'),
                onTap: () {
                  null;
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
