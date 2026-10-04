import 'package:flutter/material.dart';

void main() => runApp(const CafeteriaApp());

class CafeteriaApp extends StatelessWidget {
  const CafeteriaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mi pedido',
      home: const PantallaPedido(),
    );
  }
}

class PantallaPedido extends StatefulWidget {
  const PantallaPedido({super.key});

  @override
  State<PantallaPedido> createState() => _PantallaPedidoState();
}

class _PantallaPedidoState extends State<PantallaPedido> {
  static const List<Producto> productos = [
    Producto(nombre: 'Café', precio: 10.0),
    Producto(nombre: 'Sándwich', precio: 25.0),
    Producto(nombre: 'Jugo', precio: 12.0),
  ];

  late List<int> cantidades;

  @override
  void initState() {
    super.initState();
    cantidades = List.filled(productos.length, 0);
  }

  void _cambiarCantidad(int indice, int delta) {
    setState(() {
      final nueva = cantidades[indice] + delta;
      if (nueva >= 0) {
        cantidades[indice] = nueva;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mi pedido')),
      body: Column(
        children: [
          for (int i = 0; i < productos.length; i++)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    '${productos[i].nombre} - Q${productos[i].precio.toStringAsFixed(2)}',
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () => _cambiarCantidad(i, -1),
                    ),
                    Text('${cantidades[i]}'),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () => _cambiarCantidad(i, 1),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Producto {
  final String nombre;
  final double precio;
  const Producto({required this.nombre, required this.precio});

}