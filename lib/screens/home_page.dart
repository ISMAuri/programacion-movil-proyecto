import 'package:flutter/material.dart';
import '../models/producto.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Producto producto = Producto(
    nombre: "Producto X",
    codigo: "P001",
    categoria: "Categoría 1",
    precio: 120.52,
    cantidad: 50,
  );
  bool mostrarDetalles = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Inventario Fácil',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blueGrey[100],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 15,
          children: [
            Text(
              'Cantidad de Stock de ${producto.nombre}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 10,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      producto.venderProducto(1);
                    });
                  },
                  child: Icon(Icons.remove),
                ),
                Text(
                  '${producto.cantidad}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      producto.agregarStock(1);
                    });
                  },
                  child: Icon(Icons.add),
                ),
              ],
            ),
            if (mostrarDetalles)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    spacing: 7,
                    children: [
                      Text(
                        'Nombre: ${producto.nombre}',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        'Código: ${producto.codigo}',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        'Categoría: ${producto.categoria}',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        'Precio: L. ${producto.precio.toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
            onPressed: () {
              setState(() {
                mostrarDetalles = !mostrarDetalles;
              });
            },
            child: Icon(Icons.visibility),
          ),
    );
  }
}
