import 'package:flutter/foundation.dart';

import 'tarea.dart';

/// Valor centinela para distinguir «no cambies este campo» de «ponlo en null»
/// dentro de [FiltroTareas.copyWith].
const Object _sinCambio = Object();

/// Filtro del historial. Es un valor inmutable: cada cambio produce una
/// instancia nueva, nunca muta la anterior.
@immutable
class FiltroTareas {
  const FiltroTareas({this.mes, this.categoria, this.estado, this.texto = ''});

  /// Mes seleccionado (se comparan año y mes; el día se ignora).
  final DateTime? mes;
  final CategoriaTarea? categoria;
  final EstadoTarea? estado;

  /// Búsqueda por título o nota.
  final String texto;

  bool get tieneFiltrosActivos =>
      mes != null ||
      categoria != null ||
      estado != null ||
      texto.trim().isNotEmpty;

  FiltroTareas copyWith({
    Object? mes = _sinCambio,
    Object? categoria = _sinCambio,
    Object? estado = _sinCambio,
    String? texto,
  }) {
    return FiltroTareas(
      mes: identical(mes, _sinCambio) ? this.mes : mes as DateTime?,
      categoria: identical(categoria, _sinCambio)
          ? this.categoria
          : categoria as CategoriaTarea?,
      estado: identical(estado, _sinCambio)
          ? this.estado
          : estado as EstadoTarea?,
      texto: texto ?? this.texto,
    );
  }

  /// Regla única de filtrado. El repositorio la aplica; los widgets nunca
  /// filtran por su cuenta.
  bool coincide(Tarea tarea) {
    final mesFiltro = mes;
    if (mesFiltro != null &&
        (tarea.fecha.year != mesFiltro.year ||
            tarea.fecha.month != mesFiltro.month)) {
      return false;
    }
    if (categoria != null && tarea.categoria != categoria) return false;
    if (estado != null && tarea.estado != estado) return false;

    final consulta = texto.trim().toLowerCase();
    if (consulta.isEmpty) return true;
    return tarea.titulo.toLowerCase().contains(consulta) ||
        tarea.nota.toLowerCase().contains(consulta);
  }

  @override
  bool operator ==(Object other) {
    return other is FiltroTareas &&
        other.mes == mes &&
        other.categoria == categoria &&
        other.estado == estado &&
        other.texto == texto;
  }

  @override
  int get hashCode => Object.hash(mes, categoria, estado, texto);
}
