import 'package:flutter/material.dart';
import 'models/producto.dart';
import 'widgets/producto_pedido.dart';

class PantallaPedido extends StatefulWidget {
  const PantallaPedido({super.key});

  @override
  State<PantallaPedido> createState() => _PantallaPedido();
}

class _PantallaPedido extends State<PantallaPedido> {
  final List<Producto> productos = [
    Producto(nombre: 'Café', precio: 10.00),
    Producto(nombre: 'Sándwich', precio: 25.00),
    Producto(nombre: 'Jugo', precio: 12.00),
  ];

  late List<int> cantidades;

  @override
  void initState() {
    super.initState();
    cantidades = List<int>.filled(productos.length, 0);
  }

  void _cambiarCantidad(int indice, int delta) {
    setState(() {
      final nueva = cantidades[indice] + delta;
      if (nueva >= 0) {
        cantidades[indice] = nueva;
      }
    });
  }

  double get _total {
    double suma = 0;
    for (int i = 0; i < productos.length; i++) {
      suma += productos[i].precio * cantidades[i];
    }
    return suma;
  }

  void _vaciarPedido() {
    setState(() {
      for (int i = 0; i < cantidades.length; i++){
        cantidades[i] = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi pedido'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
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
            ),
            const Divider(thickness: 2),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Q${_total.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _vaciarPedido,
                icon: const Icon(Icons.delete_outline),
                label: const Text('Vaciar pedido'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}