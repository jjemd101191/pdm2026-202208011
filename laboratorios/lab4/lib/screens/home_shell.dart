import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/proveedores.dart';
import 'historial_tab.dart';
import 'inicio_tab.dart';
import 'proximamente_tab.dart';

/// Contenedor de pestañas. El índice vive en un provider y las pantallas se
/// mantienen vivas dentro de un IndexedStack, por eso cada una conserva su
/// scroll al ir y volver.
class HomeShell extends ConsumerWidget {
  const HomeShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final indice = ref.watch(indicePestanaProvider);

    return Scaffold(
      body: IndexedStack(
        index: indice,
        children: const [
          InicioTab(),
          HistorialTab(),
          ProximamenteTab(
            titulo: 'Calendario',
            icono: Icons.calendar_month_outlined,
            mensaje:
                'Aquí verás tus entregas organizadas por fecha. '
                'La pantalla está planificada para la S16.',
          ),
          ProximamenteTab(
            titulo: 'Ajustes',
            icono: Icons.settings_outlined,
            mensaje:
                'Preferencias de la cuenta y notificaciones. '
                'La pantalla está planificada para la S16.',
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: indice,
        onDestinationSelected: ref
            .read(indicePestanaProvider.notifier)
            .seleccionar,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Inicio',
          ),
          NavigationDestination(
            icon: Icon(Icons.history_outlined),
            selectedIcon: Icon(Icons.history),
            label: 'Historial',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(Icons.calendar_month),
            label: 'Calendario',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Ajustes',
          ),
        ],
      ),
    );
  }
}
