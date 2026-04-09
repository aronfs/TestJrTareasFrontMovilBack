import 'package:flutter/material.dart';
import 'package:sistema_ventas_app_v1/src/models/tareas_model.dart';
import 'package:sistema_ventas_app_v1/src/routes/app_routes.dart';
import 'package:sistema_ventas_app_v1/src/services/tareas_service.dart';
import 'package:sistema_ventas_app_v1/src/theme/app_theme.dart';
import 'package:sistema_ventas_app_v1/src/utility/navigation_service.dart';

class TareaItem extends StatelessWidget {
  final Tareas tarea;
  final TareaService tareaService;

  const TareaItem({super.key, required this.tarea, required this.tareaService});

  @override
  Widget build(BuildContext context) {
    final estaCompletada = tarea.estadoTarea == true;
    final estadoLabel = estaCompletada ? 'Completada' : 'Pendiente';
    final estadoColor = estaCompletada
        ? const Color(0xFFDCEDE6)
        : const Color(0xFFEAF3EE);

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.paper,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: const Color(0xFFE3DCCE)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE6EFEB),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.task_alt_rounded,
                    color: AppTheme.ink,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tarea.tituloTarea ?? 'Titulo no disponible',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Seguimiento activo',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.muted,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: estadoColor,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    estadoLabel,
                    style: const TextStyle(
                      color: AppTheme.ink,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              tarea.descripcion ?? 'Descripcion no disponible',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.text,
              ),
            ),
            if ((tarea.comentario ?? '').trim().isNotEmpty) ...[
              const SizedBox(height: 14),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F3EA),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Text(
                  tarea.comentario ?? '',
                  style: const TextStyle(color: AppTheme.muted, height: 1.4),
                ),
              ),
            ],
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      navigationService.navigateTo(
                        AppRoutes.tareasForm,
                        arguments: tarea,
                      );
                    },
                    icon: const Icon(Icons.edit_outlined),
                    label: const Text('Editar'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: estaCompletada
                        ? null
                        : () => _completarTarea(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.mint,
                      foregroundColor: AppTheme.ink,
                    ),
                    icon: const Icon(Icons.check_circle_outline_rounded),
                    label: Text(estaCompletada ? 'Completada' : 'Completar'),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton.filledTonal(
                  onPressed: () => _confirmarEliminacion(context),
                  style: IconButton.styleFrom(
                    backgroundColor: const Color(0xFFF4E3DF),
                    foregroundColor: AppTheme.coral,
                  ),
                  icon: const Icon(Icons.delete_outline_rounded),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _completarTarea(BuildContext context) async {
    final confirmacion = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Completar tarea'),
        content: const Text('Esta accion marcara la tarea como completada.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Completar'),
          ),
        ],
      ),
    );

    if (confirmacion == true) {
      if (!context.mounted) return;
      await tareaService.completearTarea(context: context, idTarea: tarea.idTarea);
    }
  }

  Future<void> _confirmarEliminacion(BuildContext context) async {
    final confirmacion = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar tarea'),
        content: const Text('La tarea dejara de estar disponible en el listado.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmacion == true) {
      if (!context.mounted) return;
      await tareaService.inactivarTarea(context: context, idTarea: tarea.idTarea);
    }
  }
}
