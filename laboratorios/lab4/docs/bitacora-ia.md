# Bitácora de uso de IA · Lab 4 (S15)

Registro de la sesión de trabajo sobre la carpeta `Proyectos aparte/Lab4`.
Formato tomado de `docs/bitacora-ia.md` del repositorio del equipo.

---

## 2026-10-22 · Equipo 05 — implementación del laboratorio en `Lab4`

- **Herramienta:** Claude Code (asistente de código).
- **Especificación:** «Implementa el laboratorio de la S15 en
  `Proyectos aparte/Lab4`: navegación con la pestaña activa en un `Notifier` y
  las pantallas en un `IndexedStack`; «Ver todo» que navegue cambiando el
  provider, sin callbacks por constructor; filtro inmutable en un `Notifier`
  del que dependa la lista; estados de carga, error con Reintentar, vacío según
  el filtro y datos; `Dismissible` con `key = id` que borre primero en la base
  y vuelva la fila si falla; SnackBar con Deshacer que restaure el registro
  idéntico; pruebas de widget del filtro y de borrar/deshacer. No implementar
  edición (es la S16) ni tocar la app de `Proyecto final`.»
- **Resultado:** app TaskU completa en Flutter con Riverpod, repositorio en
  memoria con latencia y variante persistente, ocho tareas de demostración y
  nueve pruebas automatizadas.
- **Aceptado:** la separación modelo / repositorio / estado / pantallas; el
  `AsyncNotifier` cuya `build` hace `ref.watch` del filtro; `confirmDismiss`
  para borrar antes de sacar la fila; `ValueKey(tarea.id)`; la persistencia con
  `shared_preferences` para cumplir «cerrar y abrir la app».
- **Rechazado / corregido durante la revisión:**
  - Se planteó usar `onDismissed` y luego invalidar el provider. **Rechazado:**
    la fila ya se habría ido antes de saber si la base falló, y al invalidar
    podía quedar un `Dismissible` despedido dentro del árbol. Se cambió a
    `confirmDismiss`, que borra primero y devuelve `false` para que la fila
    regrese cuando el repositorio lanza.
  - Se consideró `key: ValueKey(index)`. **Rechazado:** al borrar la fila 2 de
    5, los registros 3–5 cambian de índice y Flutter reutilizaría el estado del
    elemento equivocado. La identidad es el id.
  - Se propuso trabajar solo en memoria, como permite el laboratorio.
    **Rechazado:** la prueba obligatoria de cerrar y abrir la app no se podría
    cumplir. Se añadió `RepositorioTareasPersistente`, con vuelta a memoria si
    la plataforma no puede guardar preferencias.
  - La primera versión de los chips intentaba leer el `ref` con
    `ConsumerStatefulElement`, una API que no existe. **Corregido:** el panel
    recibe callbacks del widget que sí tiene `ref`.
  - Riverpod 3 ya no expone `valueOrNull`; el analizador lo marcó. **Corregido:**
    se usa `AsyncValue.value`, que en esta versión es nullable.
  - Los estados de error y vacío desbordaban en una ventana de 600 px (y la
    fuente de prueba Ahem hace el texto más ancho). **Corregido:** se
    envolvieron en un contenedor centrado y desplazable, y las pruebas usan una
    ventana de 400 × 800 lógicos.
  - Al restaurar después de cambiar el filtro, la tarea se insertaba en una
    vista que ya no le correspondía. **Corregido:** antes de insertarla se
    comprueba `filtro.coincide(tarea)`.
  - `flutter analyze` falla en esta máquina con `exit 255` por el servidor LSP,
    como ya documentó el equipo en la S14. **Rechazado** concluir que el código
    estaba mal: `dart analyze` responde `No issues found!` y es el mismo
    analizador.
- **Verificación:** `dart format --output=none --set-exit-if-changed .` sin
  cambios; `dart analyze` sin observaciones; `flutter test` con 9 pruebas en
  verde (navegación y scroll, filtro, vacío, error con Reintentar, borrar y
  deshacer, fallo de borrado y persistencia). **Pendiente:** ejecutar la app en
  un emulador o dispositivo antes de subir el PR; en esta sesión solo se
  verificó con pruebas automatizadas.
- **Commit / PR:** pendiente. La carpeta se dejó sin commitear para que el
  equipo decida la rama (`feat/navegacion` y `feat/<issue>-filtro`) y abra los
  PR con la plantilla.
