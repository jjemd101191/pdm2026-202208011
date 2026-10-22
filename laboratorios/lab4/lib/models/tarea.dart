import 'package:flutter/foundation.dart';

/// Categorías con las que se clasifican las tareas de TaskU.
enum CategoriaTarea {
  universidad('Universidad'),
  trabajo('Trabajo'),
  personal('Personal'),
  hogar('Hogar');

  const CategoriaTarea(this.etiqueta);

  final String etiqueta;
}

/// Estado de una tarea dentro del historial.
enum EstadoTarea {
  pendiente('Pendiente'),
  completada('Completada');

  const EstadoTarea(this.etiqueta);

  final String etiqueta;
}

/// Registro inmutable del historial de tareas.
///
/// El [id] es la identidad del registro: se conserva al restaurar una tarea
/// después de deshacer un borrado.
@immutable
class Tarea {
  const Tarea({
    required this.id,
    required this.titulo,
    required this.categoria,
    required this.estado,
    required this.fecha,
    this.nota = '',
  });

  final String id;
  final String titulo;
  final CategoriaTarea categoria;
  final EstadoTarea estado;
  final DateTime fecha;
  final String nota;

  Tarea copyWith({
    String? id,
    String? titulo,
    CategoriaTarea? categoria,
    EstadoTarea? estado,
    DateTime? fecha,
    String? nota,
  }) {
    return Tarea(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      categoria: categoria ?? this.categoria,
      estado: estado ?? this.estado,
      fecha: fecha ?? this.fecha,
      nota: nota ?? this.nota,
    );
  }

  Map<String, Object?> toJson() => {
    'id': id,
    'titulo': titulo,
    'categoria': categoria.name,
    'estado': estado.name,
    'fecha': fecha.toIso8601String(),
    'nota': nota,
  };

  factory Tarea.fromJson(Map<String, Object?> json) {
    return Tarea(
      id: json['id']! as String,
      titulo: json['titulo']! as String,
      categoria: CategoriaTarea.values.firstWhere(
        (categoria) => categoria.name == json['categoria'],
        orElse: () => CategoriaTarea.personal,
      ),
      estado: EstadoTarea.values.firstWhere(
        (estado) => estado.name == json['estado'],
        orElse: () => EstadoTarea.pendiente,
      ),
      fecha: DateTime.parse(json['fecha']! as String),
      nota: (json['nota'] as String?) ?? '',
    );
  }

  /// Orden del historial: la fecha más reciente primero y, si coincide,
  /// un orden estable por id para que la lista no baile entre consultas.
  static int compararPorFecha(Tarea a, Tarea b) {
    final porFecha = b.fecha.compareTo(a.fecha);
    return porFecha != 0 ? porFecha : a.id.compareTo(b.id);
  }

  @override
  bool operator ==(Object other) {
    return other is Tarea &&
        other.id == id &&
        other.titulo == titulo &&
        other.categoria == categoria &&
        other.estado == estado &&
        other.fecha == fecha &&
        other.nota == nota;
  }

  @override
  int get hashCode => Object.hash(id, titulo, categoria, estado, fecha, nota);

  @override
  String toString() => 'Tarea($id, $titulo)';
}
