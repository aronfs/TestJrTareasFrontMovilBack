import 'package:go_router/go_router.dart';
import 'package:sistema_ventas_app_v1/src/routes/app_routes.dart';
import 'package:sistema_ventas_app_v1/src/ui/pages/main_screen.dart';

final List<GoRoute> mainRoutes = [
  GoRoute(
    path: AppRoutes.mainScreen,
    builder: (context, state) => MainScreen(),
  ),
];