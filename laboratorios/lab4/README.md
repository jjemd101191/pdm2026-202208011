# Lab 4 · Navegación, filtros y borrar con Deshacer

**TaskU · Equipo 05 · Programación de Dispositivos Móviles · S15**

App Flutter autocontenida que implementa los tres entregables del laboratorio:
navegación real entre pantallas, un historial que se filtra solo cuando cambia
el filtro y borrado con Deshacer.

## Cómo ejecutarlo

```bash
flutter pub get
flutter run          # Android, iOS, web o Windows
```

Verificación local:

```bash
dart format --output=none --set-exit-if-changed .
dart analyze
flutter test
```

> En la máquina del equipo `flutter analyze` termina con `exit 255` por un fallo
> del servidor LSP en Windows. `dart analyze` usa el mismo analizador y responde
> `No issues found!`; en el CI (Ubuntu) corre `flutter analyze`.

## Qué cubre

| Requisito | Dónde |
|---|---|
| Pestaña activa en un `Notifier` | `lib/state/proveedores.dart` (`IndicePestanaNotifier`) |
| Pantallas en `IndexedStack` (conservan scroll) | `lib/screens/home_shell.dart` |
| Navegar desde otra pantalla por provider | «Ver todo» en `lib/screens/inicio_tab.dart` |
| Pestañas sin pantalla muestran «Próximamente» | `lib/screens/proximamente_tab.dart` |
| Filtro inmutable | `lib/models/filtro_tareas.dart` (`mes`, `categoría`, `estado`, texto) |
| La lista hace `ref.watch` del filtro | `ListaTareasNotifier.build` en `lib/state/proveedores.dart` |
| Estados: cargando, error + Reintentar, vacío, datos | `lib/screens/historial_tab.dart` y `lib/widgets/estado_lista.dart` |
| `Dismissible` con `key = id` | `lib/screens/historial_tab.dart` |
| Borra primero en la base y revierte si falla | `ListaTareasNotifier.eliminar` + `confirmDismiss` |
| Deshacer restaura el registro idéntico | `ListaTareasNotifier.restaurar` + `SnackBarAction` |
| Persistencia al cerrar y abrir | `RepositorioTareasPersistente` (`shared_preferences`) |

## Arquitectura

```
lib/
  main.dart                  → arranque + repositorio persistente
  app.dart                   → MaterialApp
  theme.dart                 → paleta y tema de TaskU
  models/
    tarea.dart               → registro inmutable (id estable, JSON, igualdad)
    filtro_tareas.dart       → filtro inmutable + regla única de coincidencia
  data/
    datos_demo.dart          → 8 tareas relativas al mes actual
    repositorio_tareas.dart  → contrato, memoria y persistencia
  state/
    proveedores.dart         → pestaña, filtro y lista (Riverpod Notifier/AsyncNotifier)
  screens/
    home_shell.dart          → NavigationBar + IndexedStack
    inicio_tab.dart          → resumen y «Ver todo»
    historial_tab.dart       → filtros, estados y borrado con Deshacer
    proximamente_tab.dart    → marcador para Calendario y Ajustes
  widgets/
    estado_lista.dart        → cargando / error / vacío
    tarjeta_tarea.dart       → fila del historial
```

Flujo del filtro: el usuario toca un chip → `FiltroTareasNotifier` publica un
objeto nuevo → `ListaTareasNotifier.build` (que hace `ref.watch`) vuelve a
consultar al repositorio. No existe ningún botón de «recargar».

Flujo del borrado: `confirmDismiss` llama primero al repositorio. Si la base
responde bien, la fila sale y aparece el SnackBar «Deshacer»; si falla, el
método devuelve `false` y Flutter devuelve la fila a su sitio.

## Pruebas

`flutter test` ejecuta 9 pruebas en verde:

- `test/navegacion_test.dart` — cada pestaña responde, «Ver todo» navega y el
  historial conserva el scroll al ir y volver.
- `test/filtro_test.dart` — categoría y mes cambian la lista sin recargar,
  estado vacío según el filtro, error con Reintentar.
- `test/eliminar_deshacer_test.dart` — deslizar borra; Deshacer restaura el
  mismo registro (mismo id y mismos campos); si el borrado falla, la fila
  vuelve.
- `test/persistencia_test.dart` — lo borrado sigue borrado y lo restaurado
  sigue ahí al crear una sesión nueva del repositorio.
- `test/apoyo.dart` — helpers de montaje y de tamaño de pantalla.

## La key del Dismissible (respuesta obligatoria del PR)

La `key` debe ser el **id del registro** y no el índice porque el índice es una
posición temporal, no una identidad. Si se borra la fila 2 de 5, los registros
que estaban en las filas 3, 4 y 5 pasan a ocupar los índices 2, 3 y 4. Con
`key = index`, Flutter reutiliza los elementos de esas posiciones y los asocia
con otros datos: puede conservar el estado de la fila equivocada (animación,
foco, `Dismissible`) o mostrar un parpadeo con el registro incorrecto. Con
`key = id`, cada `Dismissible` conserva su identidad aunque cambie de posición,
de modo que el borrado anima y elimina exactamente el registro deslizado.

## Nota de entrega

Esta carpeta es autocontenida para poder revisarla y ejecutarla sin tocar la
app del `Proyecto final`. El texto del PR y la bitácora de IA están en `docs/`.
