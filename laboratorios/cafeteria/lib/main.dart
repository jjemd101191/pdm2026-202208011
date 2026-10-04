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
          ProductoPedido(
            producto: productos[i],
            cantidad: cantidades[i],
            onIncrementar: () => _cambiarCantidad(i, 1),
            onDecrementar: () => _cambiarCantidad(i, -1),
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

class ProductoPedido extends StatelessWidget {
  final Producto producto;
  final int cantidad;
  final VoidCallback onIncrementar;
  final VoidCallback onDecrementar;

  const ProductoPedido({
    super.key,
    required this.producto,
    required this.cantidad,
    required this.onIncrementar,
    required this.onDecrementar,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  producto.nombre,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text('Q${producto.precio.toStringAsFixed(2)}',
                     style: TextStyle(color: Colors.grey[700]),
                    ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: onDecrementar,
                icon: const Icon(Icons.remove_circle_outline),
              ),
              SizedBox(
                width: 32,
                child: Text(
                  '$cantidad',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              IconButton(
                onPressed: onIncrementar,
                icon: const Icon(Icons.add_circle_outline),
              ),
            ],
          ),
        ],
      ),
    );
  }
}