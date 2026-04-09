import 'package:go_router/go_router.dart';
import 'package:sistema_ventas_app_v1/src/routes/app_routes.dart';
import 'package:sistema_ventas_app_v1/src/ui/pages/dash-board/dashboard_page.dart';

final List<GoRoute> homeRoutes = [
  GoRoute(
    path: AppRoutes.home,
    builder: (context, state) => DashboardPage(),
  ),
];