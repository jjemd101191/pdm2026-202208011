import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pdm2026e_lab4/data/datos_demo.dart';
import 'package:pdm2026e_lab4/data/repositorio_tareas.dart';
import 'package:pdm2026e_lab4/models/tarea.dart';

import 'apoyo.dart';

List<Tarea> _muchasTareas() {
  final hoy = DateTime.now();
  return List.generate(30, (indice) {
    final numero = (indice + 1).toString().padLeft(2, '0');
    return Tarea(
      id: 'tarea-$numero',
      titulo: 'Compromiso $numero',
      categoria: CategoriaTarea.universidad,
      estado: indice.isEven ? EstadoTarea.pendiente : EstadoTarea.completada,
      fecha: DateTime(
        hoy.year,
        hoy.month,
        hoy.day,
      ).subtract(Duration(days: indice)),
    );
  });
}

void main() {
  testWidgets('cada pestaña responde y el historial conserva su scroll', (
    tester,
  ) async {
    configurarPantalla(tester);
    await tester.pumpWidget(
      appDePrueba(
        RepositorioTareasEnMemoria(
          tareas: _muchasTareas(),
          retardo: Duration.zero,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Hola, Demy 👋'), findsOneWidget);

    await irAPestana(tester, 'Calendario');
    expect(find.byKey(const Key('proximamente-calendario')), findsOneWidget);
    expect(find.text('Próximamente'), findsOneWidget);

    await irAPestana(tester, 'Ajustes');
    expect(find.byKey(const Key('proximamente-ajustes')), findsOneWidget);
    expect(find.text('Próximamente'), findsOneWidget);

    await irAPestana(tester, 'Historial');
    final lista = find.byKey(const PageStorageKey<String>('historial-lista'));
    expect(lista, findsOneWidget);

    final desplazable = find
        .descendant(of: lista, matching: find.byType(Scrollable))
        .first;
    await tester.scrollUntilVisible(
      find.text('Compromiso 30'),
      300,
      scrollable: desplazable,
    );
    await tester.pumpAndSettle();

    final antes = tester.state<ScrollableState>(desplazable).position.pixels;
    expect(antes, greaterThan(0));

    await irAPestana(tester, 'Inicio');
    expect(find.text('Hola, Demy 👋'), findsOneWidget);

    await irAPestana(tester, 'Historial');
    final desplazableDeVuelta = find
        .descendant(
          of: find.byKey(const PageStorageKey<String>('historial-lista')),
          matching: find.byType(Scrollable),
        )
        .first;
    final despues = tester
        .state<ScrollableState>(desplazableDeVuelta)
        .position
        .pixels;
    expect(despues, closeTo(antes, 1));
  });

  testWidgets('«Ver todo» lleva a la pestaña del historial', (tester) async {
    configurarPantalla(tester);
    await tester.pumpWidget(
      appDePrueba(
        RepositorioTareasEnMemoria(
          tareas: tareasDemo(),
          retardo: Duration.zero,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('ver-todo')), findsOneWidget);
    expect(find.byKey(const Key('campo-busqueda')), findsNothing);

    await tester.tap(find.byKey(const Key('ver-todo')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('campo-busqueda')), findsOneWidget);
    expect(find.text('Hola, Demy 👋'), findsNothing);
  });
}
