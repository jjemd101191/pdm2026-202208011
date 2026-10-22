/// Utilidades de fecha en español, sin dependencias externas.
const List<String> _meses = [
  'enero',
  'febrero',
  'marzo',
  'abril',
  'mayo',
  'junio',
  'julio',
  'agosto',
  'septiembre',
  'octubre',
  'noviembre',
  'diciembre',
];

String _capitalizar(String texto) {
  if (texto.isEmpty) return texto;
  return texto[0].toUpperCase() + texto.substring(1);
}

/// «Octubre 2026».
String formatearMes(DateTime fecha) {
  return '${_capitalizar(_meses[fecha.month - 1])} ${fecha.year}';
}

/// «Oct», «Sep», «Nov». Se usa en los chips de mes.
String nombreMesCorto(DateTime fecha) {
  return _capitalizar(_meses[fecha.month - 1].substring(0, 3));
}

/// «22 oct».
String formatearFechaCorta(DateTime fecha) {
  return '${fecha.day} ${_meses[fecha.month - 1].substring(0, 3)}';
}

/// Primer día del mes, para normalizar el filtro.
DateTime primerDiaDelMes(DateTime fecha) => DateTime(fecha.year, fecha.month);

/// Mes desplazado [desplazamiento] meses respecto a [fecha].
DateTime mesDesplazado(DateTime fecha, int desplazamiento) {
  return DateTime(fecha.year, fecha.month + desplazamiento);
}

bool esHoy(DateTime fecha) {
  final ahora = DateTime.now();
  return fecha.year == ahora.year &&
      fecha.month == ahora.month &&
      fecha.day == ahora.day;
}
