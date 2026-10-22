import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pdm2026e_lab4/data/repositorio_tareas.dart';
import 'package:pdm2026e_lab4/models/tarea.dart';

import 'apoyo.dart';

Tarea _tareaQueSeBorra() {
  final hoy = DateTime.now();
  return Tarea(
    id: 'tarea-borrar',
    titulo: 'Tarea que se borra',
    categoria: CategoriaTarea.personal,
    estado: EstadoTarea.pendiente,
    fecha: DateTime(hoy.year, hoy.month, hoy.day),
    nota: 'Nota original que debe volver intacta',
  );
}

Tarea _tareaQueSeQueda() {
  final hoy = DateTime.now();
  return Tarea(
    id: 'tarea-queda',
    titulo: 'Tarea que se queda',
    categoria: CategoriaTarea.hogar,
    estado: EstadoTarea.completada,
    fecha: DateTime(hoy.year, hoy.month, hoy.day - 1),
  );
}

void main() {
  testWidgets('deslizar borra y Deshacer restaura el mismo registro', (
    tester,
  ) async {
    configurarPantalla(tester);
    final tarea = _tareaQueSeBorra();
    final repositorio = RepositorioTareasEnMemoria(
      tareas: [tarea, _tareaQueSeQueda()],
      retardo: Duration.zero,
    );

    await tester.pumpWidget(appDePrueba(repositorio));
    await tester.pumpAndSettle();
    await irAPestana(tester, 'Historial');

    // La key de cada Dismissible es el id del registro, no su posición.
    final claves = tester
        .widgetList<Dismissible>(find.byType(Dismissible))
        .map((widget) => widget.key)
        .toList();
    expect(claves, contains(ValueKey<String>(tarea.id)));

    await tester.drag(
      find.byKey(ValueKey<String>(tarea.id)),
      const Offset(-500, 0),
    );
    await tester.pumpAndSettle();

    expect(find.text(tarea.titulo), findsNothing);
    expect(repositorio.tareas.any((t) => t.id == tarea.id), isFalse);
    expect(find.text('Deshacer'), findsOneWidget);

    await tester.tap(find.text('Deshacer'));
    await tester.pumpAndSettle();

    expect(find.text(tarea.titulo), findsOneWidget);
    final restaurada = repositorio.tareas.firstWhere((t) => t.id == tarea.id);
    expect(restaurada, equals(tarea));
    expect(restaurada.id, tarea.id);
  });

  testWidgets('si el borrado falla, la fila vuelve a la lista', (tester) async {
    configurarPantalla(tester);
    final tarea = _tareaQueSeBorra();
    final repositorio = RepositorioTareasEnMemoria(
      tareas: [tarea, _tareaQueSeQueda()],
      retardo: Duration.zero,
      idsQueFallanAlEliminar: {tarea.id},
    );

    await tester.pumpWidget(appDePrueba(repositorio));
    await tester.pumpAndSettle();
    await irAPestana(tester, 'Historial');

    await tester.drag(
      find.byKey(ValueKey<String>(tarea.id)),
      const Offset(-500, 0),
    );
    await tester.pumpAndSettle();

    expect(find.text(tarea.titulo), findsOneWidget);
    expect(
      find.text('No se pudo eliminar la tarea. La fila sigue aquí.'),
      findsOneWidget,
    );
    expect(find.text('Deshacer'), findsNothing);
    expect(repositorio.tareas.any((t) => t.id == tarea.id), isTrue);
  });
}
