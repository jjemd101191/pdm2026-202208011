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

class PantallaPedido extends StatelessWidget {
  const PantallaPedido({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mi pedido')),
      body: const Center(
        child: Text('Aquí irán los productos'),
      ),
    );
  }
}