import 'package:go_router/go_router.dart';
import 'package:sistema_ventas_app_v1/src/routes/app_routes.dart';
import 'package:sistema_ventas_app_v1/src/routes/auth_routes.dart';
import 'package:sistema_ventas_app_v1/src/routes/historial_routes.dart';
import 'package:sistema_ventas_app_v1/src/routes/producto_routes.dart';
import 'package:sistema_ventas_app_v1/src/routes/home_routes.dart';
import 'package:sistema_ventas_app_v1/src/routes/main_routes.dart';
import 'package:sistema_ventas_app_v1/src/routes/profile_routes.dart';
import 'package:sistema_ventas_app_v1/src/routes/reporte_routes.dart';
import 'package:sistema_ventas_app_v1/src/routes/tareas_routes.dart';
import 'package:sistema_ventas_app_v1/src/routes/usuarios_routes.dart';
import 'package:sistema_ventas_app_v1/src/routes/venta_routes.dart';
import 'package:sistema_ventas_app_v1/src/utility/navigation_service.dart';

bool estaAutenticado = false;


final GoRouter router = GoRouter(
  initialLocation: AppRoutes.login,
  routes: [
     ...authRoutes,
     ...homeRoutes,
     ...mainRoutes,
     ...profileRoutes,
     ...productosRoutes,
     ...reporteRoutes,
     ...usuarioRoutes,
     ...vetnaRoutes,
     ...historialRoutes,
     ...tareasRoutes
  ],
  redirect: (context, state)  {
    // Protegemos las rutas si el usuario no esta autenticado
    final vamosACasa = state.uri.path == AppRoutes.mainScreen;
    if (!estaAutenticado && vamosACasa) {
      return AppRoutes.mainScreen;
    }
    return null; // No redirigir
  },
);

void setupNavigationService(){
  navigationService.setRouter(router);
}