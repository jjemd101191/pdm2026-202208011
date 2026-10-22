import 'package:flutter/material.dart';

import '../theme.dart';

/// Pantalla para las pestañas que el equipo aún no ha desarrollado. Ningún
/// botón de la barra queda sin respuesta.
class ProximamenteTab extends StatelessWidget {
  const ProximamenteTab({
    super.key,
    required this.titulo,
    required this.icono,
    required this.mensaje,
  });

  final String titulo;
  final IconData icono;
  final String mensaje;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(titulo)),
      body: Center(
        key: Key('proximamente-${titulo.toLowerCase()}'),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 84,
                height: 84,
                decoration: const BoxDecoration(
                  color: kIndigoSoft,
                  shape: BoxShape.circle,
                ),
                child: Icon(icono, size: 38, color: kIndigo),
              ),
              const SizedBox(height: 20),
              const Text(
                'Próximamente',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: kInk,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                mensaje,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13.5,
                  height: 1.45,
                  color: kMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
