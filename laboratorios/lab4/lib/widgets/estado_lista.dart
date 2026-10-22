import 'package:flutter/material.dart';

import '../models/filtro_tareas.dart';
import '../theme.dart';
import '../utils/fechas.dart';

/// Estado de carga de la consulta del historial.
class EstadoCargando extends StatelessWidget {
  const EstadoCargando({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      key: Key('cargando-lista'),
      child: CircularProgressIndicator(color: kIndigo),
    );
  }
}

/// Estado de error con acción de reintento. La consulta se repite al
/// invalidar el provider; no hay botón de «recargar» dentro de la lista.
class EstadoError extends StatelessWidget {
  const EstadoError({super.key, required this.onReintentar});

  final VoidCallback onReintentar;

  @override
  Widget build(BuildContext context) {
    return _CentradoScrollable(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                color: kRedSoft,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.cloud_off_outlined, color: kRed),
            ),
            const SizedBox(height: 16),
            const Text(
              'No se pudieron cargar las tareas',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: kInk,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Revisa tu conexión e inténtalo de nuevo.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: kMuted),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              key: const Key('reintentar'),
              onPressed: onReintentar,
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Estado vacío. El mensaje depende del filtro activo.
class EstadoVacio extends StatelessWidget {
  const EstadoVacio({super.key, required this.filtro, required this.onLimpiar});

  final FiltroTareas filtro;
  final VoidCallback onLimpiar;

  String get _descripcion {
    final partes = <String>[];
    if (filtro.mes != null) partes.add(formatearMes(filtro.mes!));
    if (filtro.categoria != null) partes.add(filtro.categoria!.etiqueta);
    if (filtro.estado != null) partes.add(filtro.estado!.etiqueta);
    if (filtro.texto.trim().isNotEmpty) {
      partes.add('«${filtro.texto.trim()}»');
    }
    return partes.isEmpty ? 'el historial' : partes.join(' · ');
  }

  @override
  Widget build(BuildContext context) {
    return _CentradoScrollable(
      key: const Key('estado-vacio'),
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                color: kIndigoSoft,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.search_off, color: kIndigo, size: 30),
            ),
            const SizedBox(height: 16),
            const Text(
              'No hay tareas con estos filtros',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: kInk,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'No encontramos resultados para $_descripcion.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, color: kMuted),
            ),
            const SizedBox(height: 14),
            TextButton.icon(
              key: const Key('limpiar-filtros'),
              onPressed: onLimpiar,
              icon: const Icon(Icons.filter_alt_off_outlined, size: 18),
              label: const Text('Limpiar filtros'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Centra el contenido y permite desplazarlo cuando la pantalla es baja.
class _CentradoScrollable extends StatelessWidget {
  const _CentradoScrollable({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Center(child: child),
          ),
        );
      },
    );
  }
}
