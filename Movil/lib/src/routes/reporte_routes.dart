import 'package:go_router/go_router.dart';
import 'package:sistema_ventas_app_v1/src/routes/app_routes.dart';
import 'package:sistema_ventas_app_v1/src/ui/pages/reporte/reporte_page.dart';

final List<GoRoute> reporteRoutes = [
  GoRoute(
    path: AppRoutes.reporte,
    builder: (context, state) => ReportePage(),
  ),
];