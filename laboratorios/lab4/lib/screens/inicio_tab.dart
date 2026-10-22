import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/tarea.dart';
import '../state/proveedores.dart';
import '../theme.dart';
import '../utils/fechas.dart';

/// Pestaña de inicio. Su «Ver todo» navega cambiando el provider de la
/// pestaña activa, sin recibir callbacks por constructor.
class InicioTab extends ConsumerWidget {
  const InicioTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lista = ref.watch(listaTareasProvider);
    final tareas = lista.value ?? const <Tarea>[];
    final pendientes = tareas
        .where((tarea) => tarea.estado == EstadoTarea.pendiente)
        .length;
    final completadas = tareas.length - pendientes;

    void verTodo() {
      ref.read(indicePestanaProvider.notifier).seleccionar(Pestanas.historial);
    }

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Hola, Demy 👋',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: kInk,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      formatearMes(DateTime.now()),
                      style: const TextStyle(fontSize: 13, color: kMuted),
                    ),
                  ],
                ),
                const Spacer(),
                Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(
                    color: kIndigoSoft,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.person_outline, color: kIndigo),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [kIndigo, kIndigoDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Te quedan',
                    style: TextStyle(fontSize: 13, color: Color(0xFFE0E7FF)),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    lista.isLoading ? '…' : '$pendientes tareas pendientes',
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.check_circle_outline,
                        size: 15,
                        color: Color(0xFFC7D2FE),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          '$completadas completadas en tu historial',
                          style: const TextStyle(
                            fontSize: 12.5,
                            color: Color(0xFFC7D2FE),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Últimas tareas',
                    style: TextStyle(
                      fontSize: 16.5,
                      fontWeight: FontWeight.w800,
                      color: kInk,
                    ),
                  ),
                ),
                TextButton(
                  key: const Key('ver-todo'),
                  onPressed: verTodo,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    minimumSize: const Size(0, 36),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Ver todo', style: TextStyle(fontSize: 13)),
                      SizedBox(width: 2),
                      Icon(Icons.arrow_forward, size: 16),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            ...lista.when(
              loading: () => [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(
                    child: SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.4,
                        color: kIndigo,
                      ),
                    ),
                  ),
                ),
              ],
              error: (error, stackTrace) => [
                _AvisoInicio(
                  icono: Icons.cloud_off_outlined,
                  texto: 'No se pudieron cargar las tareas.',
                  accion: TextButton(
                    onPressed: () => ref.invalidate(listaTareasProvider),
                    child: const Text('Reintentar'),
                  ),
                ),
              ],
              data: (tareas) => tareas.isEmpty
                  ? const [
                      _AvisoInicio(
                        icono: Icons.task_alt,
                        texto: 'Todavía no hay tareas que mostrar.',
                      ),
                    ]
                  : tareas.take(3).map((tarea) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _TareaReciente(tarea: tarea),
                      );
                    }).toList(),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: kSoftBg,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: kLine),
              ),
              child: const Row(
                children: [
                  Icon(Icons.swipe_left_outlined, size: 20, color: kMuted),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Desliza una tarea hacia la izquierda en el historial '
                      'para borrarla. Si te equivocas, usa Deshacer.',
                      style: TextStyle(
                        fontSize: 12,
                        height: 1.4,
                        color: kMuted,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TareaReciente extends StatelessWidget {
  const _TareaReciente({required this.tarea});

  final Tarea tarea;

  @override
  Widget build(BuildContext context) {
    final completada = tarea.estado == EstadoTarea.completada;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: kLine),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: tarea.categoria.colorSuave,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              tarea.categoria.icono,
              size: 18,
              color: tarea.categoria.color,
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tarea.titulo,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: completada ? kMuted : kInk,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${tarea.categoria.etiqueta} · '
                  '${formatearFechaCorta(tarea.fecha)}',
                  style: const TextStyle(fontSize: 11.5, color: kMuted),
                ),
              ],
            ),
          ),
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: completada ? kGreen : kAmber,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }
}

class _AvisoInicio extends StatelessWidget {
  const _AvisoInicio({required this.icono, required this.texto, this.accion});

  final IconData icono;
  final String texto;
  final Widget? accion;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kSoftBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: kLine),
      ),
      child: Row(
        children: [
          Icon(icono, size: 20, color: kMuted),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              texto,
              style: const TextStyle(fontSize: 12.5, color: kMuted),
            ),
          ),
          ?accion,
        ],
      ),
    );
  }
}
