# Descripción del Pull Request · Lab 4 (S15)

> Texto listo para pegar en el PR de la pareja. Sustituir el número del issue y
> completar las capturas antes de enviarlo.

## Qué cambia

Agrega la navegación por provider con `IndexedStack`, el historial filtrable de
TaskU y el borrado con Deshacer. El filtro es un objeto inmutable del que
depende la lista, de modo que la consulta se repite sola al cambiarlo. Borrar
primero en el repositorio y ofrecer Deshacer evita perder registros por un
deslizamiento accidental.

Cierra #<número del issue>

## Cómo probarlo

1. `flutter pub get && flutter run`.
2. Recorrer las cuatro pestañas: Inicio, Historial, Calendario («Próximamente»)
   y Ajustes («Próximamente»). En Inicio, pulsar «Ver todo» y comprobar que
   abre Historial.
3. En Historial, cambiar mes, categoría, estado o texto. La lista debe cambiar
   sin pulsar ningún botón de recargar; una búsqueda sin resultados debe
   mostrar el estado vacío con «Limpiar filtros».
4. Deslizar una fila hacia la izquierda: desaparece y aparece el SnackBar con
   «Deshacer». Pulsarlo y comprobar que vuelve con la misma categoría, fecha,
   nota e id.
5. Cerrar y abrir la app: lo borrado sigue borrado y lo restaurado sigue ahí.

## Capturas

- [ ] Inicio con «Ver todo».
- [ ] Historial con filtro y estado vacío.
- [ ] SnackBar «Deshacer» después de deslizar.

## Checklist del autor

- [x] `dart format --output=none --set-exit-if-changed .`, `dart analyze` sin
      observaciones y `flutter test` en verde (9 pruebas).
- [ ] Probé en un dispositivo o emulador. _(Pendiente antes de enviar el PR.)_
- [x] Sin acceso a SQL ni a `http` dentro de widgets.
- [x] Sin `print` de depuración ni código comentado que ya no se usa.
- [x] Uso de IA registrado en `docs/bitacora-ia.md`.
- [ ] Decisión de arquitectura en `docs/adr/` (no aplica: es el patrón que ya
      usa el equipo).

## Para quien revisa

Mirar con cuidado:

- Que `confirmDismiss` no saque la fila si `eliminar` lanza (repositorio de
  prueba con `idsQueFallanAlEliminar`).
- Que `restaurar` conserve el mismo `id` y no inserte duplicados.
- Que cambiar el filtro mientras el SnackBar está visible no meta en la vista
  una tarea que ya no coincide.
- Que el scroll del historial se conserve al cambiar de pestaña y volver.

## Pregunta obligatoria: ¿por qué la key del Dismissible debe ser el id y no el índice?

Porque el índice es una **posición temporal**, no la identidad del registro. Si
se borra la fila 2 de 5, los registros de las filas 3, 4 y 5 pasan a ocupar los
índices 2, 3 y 4. Con `ValueKey(index)`, Flutter reutiliza los elementos de esas
posiciones y los empareja con otros datos: puede conservar la animación, el foco
o el estado del `Dismissible` equivocado, o animar la fila incorrecta. Con
`ValueKey(tarea.id)`, cada fila mantiene su identidad aunque cambie de posición,
así que el deslizamiento borra exactamente el registro que el usuario tocó y la
lista puede reconstruirse sin confusiones.
