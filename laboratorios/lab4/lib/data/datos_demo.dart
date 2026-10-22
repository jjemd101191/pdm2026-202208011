import '../models/tarea.dart';

/// Datos de demostración de TaskU.
///
/// Las fechas son relativas a [ahora] para que el historial siempre tenga
/// tareas del mes actual, del anterior y del siguiente.
List<Tarea> tareasDemo({DateTime? ahora}) {
  final hoy = ahora ?? DateTime.now();
  DateTime enDias(int dias) =>
      DateTime(hoy.year, hoy.month, hoy.day).add(Duration(days: dias));
  final mesAnterior = DateTime(hoy.year, hoy.month - 1, 18);
  final mesSiguiente = DateTime(hoy.year, hoy.month + 1, 5);

  return [
    Tarea(
      id: 'tarea-01',
      titulo: 'Entrega del proyecto final',
      categoria: CategoriaTarea.universidad,
      estado: EstadoTarea.pendiente,
      fecha: enDias(2),
      nota: 'Sistemas Operativos · subir el informe a Moodle',
    ),
    Tarea(
      id: 'tarea-02',
      titulo: 'Leer el capítulo 6 de UX',
      categoria: CategoriaTarea.universidad,
      estado: EstadoTarea.pendiente,
      fecha: enDias(1),
      nota: 'Diseño de interfaces · toma de apuntes',
    ),
    Tarea(
      id: 'tarea-03',
      titulo: 'Informe de laboratorio de Redes',
      categoria: CategoriaTarea.universidad,
      estado: EstadoTarea.completada,
      fecha: enDias(-2),
      nota: 'Práctica de subredes entregada',
    ),
    Tarea(
      id: 'tarea-04',
      titulo: 'Reunión con el cliente',
      categoria: CategoriaTarea.trabajo,
      estado: EstadoTarea.pendiente,
      fecha: enDias(0),
      nota: 'Revisar el alcance del sprint',
    ),
    Tarea(
      id: 'tarea-05',
      titulo: 'Actualizar el blog del portafolio',
      categoria: CategoriaTarea.personal,
      estado: EstadoTarea.completada,
      fecha: enDias(-5),
      nota: 'Publicar el caso de estudio de TaskU',
    ),
    Tarea(
      id: 'tarea-06',
      titulo: 'Comprar la despensa de la semana',
      categoria: CategoriaTarea.hogar,
      estado: EstadoTarea.pendiente,
      fecha: enDias(3),
      nota: 'Mercado del barrio',
    ),
    Tarea(
      id: 'tarea-07',
      titulo: 'Examen parcial de Bases de Datos',
      categoria: CategoriaTarea.universidad,
      estado: EstadoTarea.completada,
      fecha: mesAnterior,
      nota: 'Unidad 3 · normalización',
    ),
    Tarea(
      id: 'tarea-08',
      titulo: 'Presentación del anteproyecto',
      categoria: CategoriaTarea.universidad,
      estado: EstadoTarea.pendiente,
      fecha: mesSiguiente,
      nota: 'Preparar diapositivas y demo',
    ),
  ];
}
