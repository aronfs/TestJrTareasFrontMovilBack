import 'package:go_router/go_router.dart';
import 'package:sistema_ventas_app_v1/src/routes/app_routes.dart';
import 'package:sistema_ventas_app_v1/src/ui/pages/venta/venta_page.dart';

final List<GoRoute> vetnaRoutes = [
  GoRoute(
    path: AppRoutes.venta,
    builder: (context, state) => VentaPage(),
  ),
];