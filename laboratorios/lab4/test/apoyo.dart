import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pdm2026e_lab4/app.dart';
import 'package:pdm2026e_lab4/data/repositorio_tareas.dart';
import 'package:pdm2026e_lab4/state/proveedores.dart';

/// Monta la app con un repositorio de prueba (normalmente en memoria y sin
/// latencia) para que las pruebas sean deterministas.
Widget appDePrueba(RepositorioTareas repositorio) {
  return ProviderScope(
    overrides: [repositorioTareasProvider.overrideWithValue(repositorio)],
    child: const TaskuApp(),
  );
}

/// Usa una ventana de teléfono (400 x 800 lógicos) para que las pantallas
/// tengan el espacio con el que se diseñaron.
void configurarPantalla(WidgetTester tester) {
  tester.view.physicalSize = const Size(1200, 2400);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
}

Future<void> irAPestana(WidgetTester tester, String etiqueta) async {
  await tester.tap(
    find.descendant(
      of: find.byType(NavigationBar),
      matching: find.text(etiqueta),
    ),
  );
  await tester.pumpAndSettle();
}
