import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'data/datos_demo.dart';
import 'data/repositorio_tareas.dart';
import 'state/proveedores.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final repositorio = await _crearRepositorio();

  runApp(
    ProviderScope(
      overrides: [repositorioTareasProvider.overrideWithValue(repositorio)],
      child: const TaskuApp(),
    ),
  );
}

/// Prefiere el repositorio persistente; si la plataforma no puede guardar
/// preferencias, la app sigue funcionando con datos en memoria.
Future<RepositorioTareas> _crearRepositorio() async {
  try {
    return await RepositorioTareasPersistente.crear();
  } on Object {
    return RepositorioTareasEnMemoria(tareas: tareasDemo());
  }
}
