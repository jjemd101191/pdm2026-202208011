import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/filtro_tareas.dart';
import '../models/tarea.dart';
import '../state/proveedores.dart';
import '../theme.dart';
import '../utils/fechas.dart';
import '../widgets/estado_lista.dart';
import '../widgets/tarjeta_tarea.dart';

/// Pestaña del historial: filtros, estados de la consulta y borrado con
/// deshacer.
class HistorialTab extends ConsumerStatefulWidget {
  const HistorialTab({super.key});

  @override
  ConsumerState<HistorialTab> createState() => _HistorialTabState();
}

class _HistorialTabState extends ConsumerState<HistorialTab> {
  final TextEditingController _busqueda = TextEditingController();

  @override
  void dispose() {
    _busqueda.dispose();
    super.dispose();
  }

  void _limpiarFiltros() {
    _busqueda.clear();
    ref.read(filtroTareasProvider.notifier).limpiar();
  }

  Future<bool> _eliminar(Tarea tarea) async {
    final eliminada = await ref
        .read(listaTareasProvider.notifier)
        .eliminar(tarea);

    if (!mounted) return eliminada;
    final mensajero = ScaffoldMessenger.of(context);
    mensajero.hideCurrentSnackBar();

    if (!eliminada) {
      mensajero.showSnackBar(
        const SnackBar(
          content: Text('No se pudo eliminar la tarea. La fila sigue aquí.'),
        ),
      );
      return false;
    }

    mensajero.showSnackBar(
      SnackBar(
        content: Text('«${tarea.titulo}» eliminada'),
        duration: const Duration(seconds: 6),
        action: SnackBarAction(
          label: 'Deshacer',
          textColor: const Color(0xFFFBBF24),
          onPressed: () => _restaurar(tarea),
        ),
      ),
    );
    return true;
  }

  Future<void> _restaurar(Tarea tarea) async {
    try {
      await ref.read(listaTareasProvider.notifier).restaurar(tarea);
    } on Object {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo restaurar la tarea.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtro = ref.watch(filtroTareasProvider);
    final lista = ref.watch(listaTareasProvider);
    final mesActual = primerDiaDelMes(DateTime.now());
    final notifier = ref.read(filtroTareasProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial'),
        actions: [
          if (filtro.tieneFiltrosActivos)
            TextButton(
              key: const Key('limpiar-filtros-app'),
              onPressed: _limpiarFiltros,
              child: const Text('Limpiar'),
            ),
        ],
      ),
      body: Column(
        children: [
          _PanelFiltros(
            filtro: filtro,
            busqueda: _busqueda,
            mesActual: mesActual,
            onTexto: notifier.cambiarTexto,
            onMes: notifier.cambiarMes,
            onCategoria: notifier.cambiarCategoria,
            onEstado: notifier.cambiarEstado,
          ),
          const Divider(height: 1, color: kLine),
          Expanded(
            child: lista.when(
              loading: () => const EstadoCargando(),
              error: (error, stackTrace) => EstadoError(
                onReintentar: () => ref.invalidate(listaTareasProvider),
              ),
              data: (tareas) {
                if (tareas.isEmpty) {
                  return EstadoVacio(
                    filtro: filtro,
                    onLimpiar: _limpiarFiltros,
                  );
                }
                return ListView.separated(
                  key: const PageStorageKey<String>('historial-lista'),
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                  itemCount: tareas.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final tarea = tareas[index];
                    return Dismissible(
                      // La key es el id del registro, nunca la posición.
                      key: ValueKey<String>(tarea.id),
                      direction: DismissDirection.endToStart,
                      confirmDismiss: (direction) => _eliminar(tarea),
                      background: const _FondoBorrar(),
                      child: TarjetaTarea(tarea: tarea),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _PanelFiltros extends StatelessWidget {
  const _PanelFiltros({
    required this.filtro,
    required this.busqueda,
    required this.mesActual,
    required this.onTexto,
    required this.onMes,
    required this.onCategoria,
    required this.onEstado,
  });

  final FiltroTareas filtro;
  final TextEditingController busqueda;
  final DateTime mesActual;
  final ValueChanged<String> onTexto;
  final ValueChanged<DateTime?> onMes;
  final ValueChanged<CategoriaTarea?> onCategoria;
  final ValueChanged<EstadoTarea?> onEstado;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            key: const Key('campo-busqueda'),
            controller: busqueda,
            onChanged: onTexto,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: 'Buscar por título o nota',
              prefixIcon: const Icon(Icons.search, size: 20, color: kMuted),
              suffixIcon: filtro.texto.isEmpty
                  ? null
                  : IconButton(
                      key: const Key('limpiar-busqueda'),
                      tooltip: 'Borrar búsqueda',
                      onPressed: () {
                        busqueda.clear();
                        onTexto('');
                      },
                      icon: const Icon(Icons.close, size: 18),
                    ),
            ),
          ),
          const SizedBox(height: 10),
          const _Etiqueta('Mes'),
          _FilaChips(
            children: [
              _chipMes(
                etiqueta: 'Todos',
                mes: null,
                clave: const Key('chip-mes-todos'),
              ),
              _chipMes(
                etiqueta: formatearMes(mesDesplazado(mesActual, -1)),
                mes: mesDesplazado(mesActual, -1),
                clave: const Key('chip-mes-anterior'),
              ),
              _chipMes(
                etiqueta: formatearMes(mesActual),
                mes: mesActual,
                clave: const Key('chip-mes-actual'),
              ),
              _chipMes(
                etiqueta: formatearMes(mesDesplazado(mesActual, 1)),
                mes: mesDesplazado(mesActual, 1),
                clave: const Key('chip-mes-siguiente'),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const _Etiqueta('Categoría'),
          _FilaChips(
            children: [
              _chipCategoria(
                etiqueta: 'Todas',
                categoria: null,
                clave: const Key('chip-categoria-todas'),
              ),
              ...CategoriaTarea.values.map(
                (categoria) => _chipCategoria(
                  etiqueta: categoria.etiqueta,
                  categoria: categoria,
                  clave: Key('chip-categoria-${categoria.name}'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const _Etiqueta('Estado'),
          _FilaChips(
            children: [
              _chipEstado(
                etiqueta: 'Todos',
                estado: null,
                clave: const Key('chip-estado-todos'),
              ),
              _chipEstado(
                etiqueta: 'Pendientes',
                estado: EstadoTarea.pendiente,
                clave: const Key('chip-estado-pendiente'),
              ),
              _chipEstado(
                etiqueta: 'Completadas',
                estado: EstadoTarea.completada,
                clave: const Key('chip-estado-completada'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _chipMes({
    required String etiqueta,
    required DateTime? mes,
    required Key clave,
  }) {
    final seleccionado = mes == null
        ? filtro.mes == null
        : filtro.mes != null &&
              filtro.mes!.year == mes.year &&
              filtro.mes!.month == mes.month;
    return ChoiceChip(
      key: clave,
      label: Text(etiqueta),
      selected: seleccionado,
      showCheckmark: false,
      visualDensity: VisualDensity.compact,
      onSelected: (_) => onMes(mes),
    );
  }

  Widget _chipCategoria({
    required String etiqueta,
    required CategoriaTarea? categoria,
    required Key clave,
  }) {
    return ChoiceChip(
      key: clave,
      label: Text(etiqueta),
      selected: filtro.categoria == categoria,
      showCheckmark: false,
      visualDensity: VisualDensity.compact,
      onSelected: (_) => onCategoria(categoria),
    );
  }

  Widget _chipEstado({
    required String etiqueta,
    required EstadoTarea? estado,
    required Key clave,
  }) {
    return ChoiceChip(
      key: clave,
      label: Text(etiqueta),
      selected: filtro.estado == estado,
      showCheckmark: false,
      visualDensity: VisualDensity.compact,
      onSelected: (_) => onEstado(estado),
    );
  }
}

class _Etiqueta extends StatelessWidget {
  const _Etiqueta(this.texto);

  final String texto;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Text(
        texto,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: kMuted,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

class _FilaChips extends StatelessWidget {
  const _FilaChips({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          for (final chip in children)
            Padding(
              padding: const EdgeInsets.only(right: 6),
              child: Center(child: chip),
            ),
        ],
      ),
    );
  }
}

class _FondoBorrar extends StatelessWidget {
  const _FondoBorrar();

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 22),
      decoration: BoxDecoration(
        color: kRed,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.delete_outline, color: Colors.white, size: 22),
          SizedBox(height: 2),
          Text(
            'Borrar',
            style: TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
