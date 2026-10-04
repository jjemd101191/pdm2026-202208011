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
  int cantidadCafe = 0;
  int cantidadSandwich = 0;
  int cantidadJugo = 0;

  void _cambiarCafe(int delta) {
    setState(() {
      final nueva = cantidadCafe + delta;
      if (nueva >= 0) {
        cantidadCafe = nueva;
      }
    });
  }

  Widget _filaEstatica(String nombre, String precio) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(child: Text(nombre)),
          Text(precio),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mi pedido')),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Café - Q10.00'),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: () => _cambiarCafe(-1),
                  ),
                  Text('$cantidadCafe'),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () => _cambiarCafe(1),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}