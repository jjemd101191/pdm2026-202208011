import 'package:flutter/material.dart';

import '../models/tarea.dart';
import '../theme.dart';
import '../utils/fechas.dart';

/// Contenido visual de una fila del historial. No conoce el repositorio ni
/// el estado: recibe la tarea y la muestra.
class TarjetaTarea extends StatelessWidget {
  const TarjetaTarea({super.key, required this.tarea});

  final Tarea tarea;

  @override
  Widget build(BuildContext context) {
    final completada = tarea.estado == EstadoTarea.completada;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: kLine),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: tarea.categoria.colorSuave,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              tarea.categoria.icono,
              size: 20,
              color: tarea.categoria.color,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tarea.titulo,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14.5,
                    height: 1.25,
                    fontWeight: FontWeight.w700,
                    color: completada ? kMuted : kInk,
                    decoration: completada
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${tarea.categoria.etiqueta} · ${formatearFechaCorta(tarea.fecha)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12, color: kMuted),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: completada ? kGreenSoft : kAmberSoft,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              tarea.estado.etiqueta,
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w600,
                color: completada ? kGreenDark : const Color(0xFF92400E),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
