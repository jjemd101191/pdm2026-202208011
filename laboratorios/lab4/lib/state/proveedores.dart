import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/datos_demo.dart';
import '../data/repositorio_tareas.dart';
import '../models/filtro_tareas.dart';
import '../models/tarea.dart';
import '../utils/fechas.dart';

/// Índices de las pestañas. Las pantallas y el shell comparten estas
/// constantes para no depender de números sueltos.
abstract final class Pestanas {
  static const int inicio = 0;
  static const int historial = 1;
  static const int calendario = 2;
  static const int ajustes = 3;
  static const int total = 4;
}

/// Repositorio de datos. `main` lo sustituye por la versión persistente y las
/// pruebas por una en memoria con latencia cero.
final repositorioTareasProvider = Provider<RepositorioTareas>((ref) {
  return RepositorioTareasEnMemoria(tareas: tareasDemo());
});

/// Pestaña activa. Vive en un Notifier para que cualquier pantalla pueda
/// navegar (por ejemplo, «Ver todo» desde Inicio) sin callbacks por
/// constructor.
class IndicePestanaNotifier extends Notifier<int> {
  @override
  int build() => Pestanas.inicio;

  void seleccionar(int indice) {
    if (indice < 0 || indice >= Pestanas.total) return;
    state = indice;
  }
}

final indicePestanaProvider = NotifierProvider<IndicePestanaNotifier, int>(
  IndicePestanaNotifier.new,
);

/// Filtro del historial. Cada método reemplaza el valor por una instancia
/// nueva; ningún widget muta el objeto.
class FiltroTareasNotifier extends Notifier<FiltroTareas> {
  @override
  FiltroTareas build() => const FiltroTareas();

  void cambiarMes(DateTime? mes) {
    state = state.copyWith(mes: mes == null ? null : primerDiaDelMes(mes));
  }

  void cambiarCategoria(CategoriaTarea? categoria) {
    state = state.copyWith(categoria: categoria);
  }

  void cambiarEstado(EstadoTarea? estado) {
    state = state.copyWith(estado: estado);
  }

  void cambiarTexto(String texto) {
    state = state.copyWith(texto: texto);
  }

  void limpiar() {
    state = const FiltroTareas();
  }
}

final filtroTareasProvider =
    NotifierProvider<FiltroTareasNotifier, FiltroTareas>(
      FiltroTareasNotifier.new,
    );

/// Lista del historial.
///
/// [build] hace `ref.watch` del filtro: al cambiar el filtro, Riverpod vuelve
/// a ejecutar la consulta sin ningún botón de «recargar».
class ListaTareasNotifier extends AsyncNotifier<List<Tarea>> {
  @override
  Future<List<Tarea>> build() {
    final filtro = ref.watch(filtroTareasProvider);
    final repositorio = ref.watch(repositorioTareasProvider);
    return repositorio.listar(filtro);
  }

  /// Borra primero en el repositorio y solo después actualiza la lista.
  /// Devuelve `false` si la fuente de datos falló, para que la fila regrese.
  Future<bool> eliminar(Tarea tarea) async {
    try {
      await ref.read(repositorioTareasProvider).eliminar(tarea.id);
    } on Object {
      return false;
    }

    final actuales = state.value;
    if (actuales != null) {
      state = AsyncData(
        actuales
            .where((existente) => existente.id != tarea.id)
            .toList(growable: false),
      );
    }
    return true;
  }

  /// Restaura el registro idéntico (mismo id y mismos datos).
  Future<void> restaurar(Tarea tarea) async {
    await ref.read(repositorioTareasProvider).restaurar(tarea);

    final actuales = state.value ?? const <Tarea>[];
    if (actuales.any((existente) => existente.id == tarea.id)) return;

    // Si el filtro cambió mientras el SnackBar estaba visible, la tarea se
    // restauró en la base pero no debe aparecer en una vista que no le
    // corresponde.
    if (!ref.read(filtroTareasProvider).coincide(tarea)) return;

    final restauradas = [...actuales, tarea]..sort(Tarea.compararPorFecha);
    state = AsyncData(restauradas);
  }
}

final listaTareasProvider =
    AsyncNotifierProvider<ListaTareasNotifier, List<Tarea>>(
      ListaTareasNotifier.new,
    );
