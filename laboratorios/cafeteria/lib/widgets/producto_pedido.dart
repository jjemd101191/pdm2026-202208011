import 'package:flutter/material.dart';
import '../models/producto.dart';

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
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                producto.nombre,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'Q${producto.precio.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                key: ValueKey('dec_${producto.nombre}'),
                onPressed: onDecrementar,
                icon: const Icon(Icons.remove_circle_outline),
              ),
              Text(
                key: ValueKey('cant_${producto.nombre}'),
                '$cantidad',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                key: ValueKey('inc_${producto.nombre}'),
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