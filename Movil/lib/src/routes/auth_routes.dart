import 'package:go_router/go_router.dart';
import 'package:sistema_ventas_app_v1/src/routes/app_routes.dart';
import '../ui/pages/auth_login.dart';

final List<GoRoute> authRoutes = [
  GoRoute(
    path: AppRoutes.login,
    builder: (context, state) => AuthLogin(),
  ),
];

