import 'package:flutter_test/flutter_test.dart';
import 'package:pdm2026e_lab4/data/repositorio_tareas.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'lo borrado y lo restaurado sobrevive a cerrar y abrir la app',
    () async {
      SharedPreferences.setMockInitialValues({});
      final referencia = DateTime(2026, 10, 22, 12);

      // Primera sesión: se siembra el historial y se borra una tarea.
      final sesionUno = await RepositorioTareasPersistente.crear(
        ahora: referencia,
      );
      final borrada = sesionUno.tareas.first;
      await sesionUno.eliminar(borrada.id);

      // Segunda sesión: la tarea sigue borrada.
      final sesionDos = await RepositorioTareasPersistente.crear(
        ahora: referencia,
      );
      expect(sesionDos.tareas.any((t) => t.id == borrada.id), isFalse);

      // Se deshace el borrado y se vuelve a abrir.
      await sesionDos.restaurar(borrada);
      final sesionTres = await RepositorioTareasPersistente.crear(
        ahora: referencia,
      );

      final restaurada = sesionTres.tareas.firstWhere(
        (t) => t.id == borrada.id,
      );
      expect(restaurada, equals(borrada));
    },
  );
}
