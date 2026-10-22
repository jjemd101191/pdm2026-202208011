import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/filtro_tareas.dart';
import '../models/tarea.dart';
import 'datos_demo.dart';

/// Contrato de datos del historial. Los widgets solo hablan con esta interfaz.
abstract interface class RepositorioTareas {
  Future<List<Tarea>> listar(FiltroTareas filtro);

  /// Borra primero en la fuente de datos. Si falla, lanza una excepción y la
  /// fila debe volver a la lista.
  Future<void> eliminar(String id);

  /// Vuelve a insertar el registro tal cual, conservando su id.
  Future<void> restaurar(Tarea tarea);
}

/// Implementación en memoria con latencia simulada, como en la S14.
///
/// [idsQueFallanAlEliminar] existe para poder demostrar y probar que, cuando
/// el borrado falla, la fila regresa en lugar de desaparecer.
class RepositorioTareasEnMemoria implements RepositorioTareas {
  RepositorioTareasEnMemoria({
    List<Tarea>? tareas,
    this.retardo = const Duration(milliseconds: 350),
    Set<String> idsQueFallanAlEliminar = const {},
  }) : _tareas = [...?tareas],
       _idsQueFallanAlEliminar = {...idsQueFallanAlEliminar};

  final Duration retardo;
  final List<Tarea> _tareas;
  final Set<String> _idsQueFallanAlEliminar;

  /// Copia de solo lectura, útil para verificar el resultado en pruebas.
  List<Tarea> get tareas => List.unmodifiable(_tareas);

  Future<void> _esperar() async {
    if (retardo > Duration.zero) {
      await Future<void>.delayed(retardo);
    }
  }

  @override
  Future<List<Tarea>> listar(FiltroTareas filtro) async {
    await _esperar();
    final resultado = _tareas.where(filtro.coincide).toList()
      ..sort(Tarea.compararPorFecha);
    return List.unmodifiable(resultado);
  }

  @override
  Future<void> eliminar(String id) async {
    await _esperar();
    if (_idsQueFallanAlEliminar.contains(id)) {
      throw StateError('No se pudo eliminar la tarea $id');
    }
    final indice = _tareas.indexWhere((tarea) => tarea.id == id);
    if (indice == -1) {
      throw StateError('La tarea $id ya no existe');
    }
    _tareas.removeAt(indice);
  }

  @override
  Future<void> restaurar(Tarea tarea) async {
    await _esperar();
    if (_tareas.any((existente) => existente.id == tarea.id)) return;
    _tareas.add(tarea);
  }
}

/// Repositorio que conserva el historial entre sesiones con
/// `shared_preferences`. Si la app se cierra y se vuelve a abrir, lo borrado
/// sigue borrado y lo restaurado sigue ahí.
class RepositorioTareasPersistente extends RepositorioTareasEnMemoria {
  RepositorioTareasPersistente._(this._prefs, List<Tarea> tareas)
    : super(tareas: tareas, retardo: const Duration(milliseconds: 350));

  static const String claveAlmacenamiento = 'pdm2026e_lab4_tareas_v1';

  final SharedPreferences _prefs;

  static Future<RepositorioTareasPersistente> crear({DateTime? ahora}) async {
    final prefs = await SharedPreferences.getInstance();
    final guardadas = prefs.getString(claveAlmacenamiento);

    List<Tarea> tareas;
    if (guardadas == null) {
      tareas = tareasDemo(ahora: ahora);
      await prefs.setString(
        claveAlmacenamiento,
        jsonEncode(tareas.map((tarea) => tarea.toJson()).toList()),
      );
    } else {
      try {
        tareas = (jsonDecode(guardadas) as List<dynamic>)
            .map((json) => Tarea.fromJson(json as Map<String, Object?>))
            .toList();
      } on Object {
        // Datos corruptos o de una versión anterior: se vuelve a sembrar.
        tareas = tareasDemo(ahora: ahora);
        await _guardarEn(prefs, tareas);
      }
    }

    return RepositorioTareasPersistente._(prefs, tareas);
  }

  @override
  Future<void> eliminar(String id) async {
    await super.eliminar(id);
    await _guardar();
  }

  @override
  Future<void> restaurar(Tarea tarea) async {
    await super.restaurar(tarea);
    await _guardar();
  }

  Future<void> _guardar() => _guardarEn(_prefs, tareas);

  static Future<void> _guardarEn(SharedPreferences prefs, List<Tarea> tareas) {
    return prefs.setString(
      claveAlmacenamiento,
      jsonEncode(tareas.map((tarea) => tarea.toJson()).toList()),
    );
  }
}
