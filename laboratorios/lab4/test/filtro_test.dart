import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pdm2026e_lab4/data/datos_demo.dart';
import 'package:pdm2026e_lab4/data/repositorio_tareas.dart';
import 'package:pdm2026e_lab4/models/filtro_tareas.dart';
import 'package:pdm2026e_lab4/models/tarea.dart';

import 'apoyo.dart';

void main() {
  testWidgets('cambiar la categoría actualiza la lista sin recargar', (
    tester,
  ) async {
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
    await irAPestana(tester, 'Historial');

    expect(find.text('Entrega del proyecto final'), findsOneWidget);
    expect(find.byType(Dismissible), findsWidgets);
    expect(find.text('Reintentar'), findsNothing);

    await tester.tap(find.byKey(const Key('chip-categoria-trabajo')));
    await tester.pumpAndSettle();

    expect(find.text('Reunión con el cliente'), findsOneWidget);
    expect(find.text('Entrega del proyecto final'), findsNothing);
    expect(find.text('Reintentar'), findsNothing);
  });

  testWidgets('el filtro de mes cambia la consulta', (tester) async {
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
    await irAPestana(tester, 'Historial');

    await tester.tap(find.byKey(const Key('chip-mes-anterior')));
    await tester.pumpAndSettle();

    expect(find.text('Examen parcial de Bases de Datos'), findsOneWidget);
    expect(find.text('Entrega del proyecto final'), findsNothing);
  });

  testWidgets('un filtro sin resultados muestra el estado vacío', (
    tester,
  ) async {
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
    await irAPestana(tester, 'Historial');

    await tester.enterText(
      find.byKey(const Key('campo-busqueda')),
      'no-existe-esta-tarea',
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('estado-vacio')), findsOneWidget);
    expect(find.text('No hay tareas con estos filtros'), findsOneWidget);
    expect(
      find.text('No encontramos resultados para «no-existe-esta-tarea».'),
      findsOneWidget,
    );
    expect(find.byType(Dismissible), findsNothing);

    await tester.tap(find.byKey(const Key('limpiar-filtros')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('estado-vacio')), findsNothing);
    expect(find.byType(Dismissible), findsWidgets);
    expect(
      tester
          .widget<TextField>(find.byKey(const Key('campo-busqueda')))
          .controller!
          .text,
      isEmpty,
    );
  });

  testWidgets('un error de la consulta ofrece Reintentar', (tester) async {
    configurarPantalla(tester);
    final repositorio = _RepositorioQueFallaUnaVez();
    await tester.pumpWidget(appDePrueba(repositorio));
    await tester.pumpAndSettle();
    await irAPestana(tester, 'Historial');

    expect(find.text('No se pudieron cargar las tareas'), findsOneWidget);
    expect(find.byKey(const Key('reintentar')), findsOneWidget);

    await tester.tap(find.byKey(const Key('reintentar')));
    await tester.pumpAndSettle();

    expect(find.text('No se pudieron cargar las tareas'), findsNothing);
    expect(find.byType(Dismissible), findsWidgets);
  });
}

class _RepositorioQueFallaUnaVez implements RepositorioTareas {
  final RepositorioTareasEnMemoria _datos = RepositorioTareasEnMemoria(
    tareas: tareasDemo(),
    retardo: Duration.zero,
  );
  int _intentos = 0;

  @override
  Future<List<Tarea>> listar(FiltroTareas filtro) async {
    _intentos++;
    if (_intentos == 1) {
      throw StateError('Fallo simulado de la consulta');
    }
    return _datos.listar(filtro);
  }

  @override
  Future<void> eliminar(String id) => _datos.eliminar(id);

  @override
  Future<void> restaurar(Tarea tarea) => _datos.restaurar(tarea);
}
