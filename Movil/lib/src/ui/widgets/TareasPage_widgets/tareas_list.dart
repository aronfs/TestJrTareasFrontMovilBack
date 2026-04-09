import 'package:flutter/material.dart';
import 'package:sistema_ventas_app_v1/src/models/tareas_model.dart';
import 'package:sistema_ventas_app_v1/src/services/tareas_service.dart';
import 'package:sistema_ventas_app_v1/src/ui/widgets/TareasPage_widgets/tarea_item.dart';

class TareaList extends StatelessWidget {
  final List<Tareas> tarea;

  const TareaList({super.key, required this.tarea});

  @override
  Widget build(BuildContext context) {
    if (tarea.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(26),
        ),
        child: const Column(
          children: [
            Icon(Icons.inbox_rounded, size: 44),
            SizedBox(height: 12),
            Text(
              'Aun no tienes tareas registradas',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 6),
            Text(
              'Crea una nueva tarea para comenzar a organizar tu flujo.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: tarea.length,
      separatorBuilder: (_, __) => const SizedBox(height: 14),
      itemBuilder: (context, index) {
        return TareaItem(tarea: tarea[index], tareaService: TareaService());
      },
    );
  }
}
