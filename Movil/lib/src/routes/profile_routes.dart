import 'package:go_router/go_router.dart';
import 'package:sistema_ventas_app_v1/src/routes/app_routes.dart';
import 'package:sistema_ventas_app_v1/src/ui/pages/profile/profile_page.dart';

final List<GoRoute> profileRoutes = [
  GoRoute(
    path: AppRoutes.profile,
    builder: (context, state) => ProfilePage(),
  ),
];