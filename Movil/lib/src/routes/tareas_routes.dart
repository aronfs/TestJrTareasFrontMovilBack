


import 'package:go_router/go_router.dart';
import 'package:sistema_ventas_app_v1/src/models/tareas_model.dart';
import 'package:sistema_ventas_app_v1/src/routes/app_routes.dart';
import 'package:sistema_ventas_app_v1/src/ui/forms/tareas_form.dart';
import 'package:sistema_ventas_app_v1/src/ui/pages/tareas/tareas_page.dart';

final List<GoRoute> tareasRoutes = [
  GoRoute(
    path: AppRoutes.tareas,
    builder: (context, state) => TareasPage()
    ),
     GoRoute(
    path: AppRoutes.tareasForm,
    builder: (context, state) {
      final tarea = state.extra as Tareas?;
      return TareasForm(tareas: tarea);
      },
    )
];