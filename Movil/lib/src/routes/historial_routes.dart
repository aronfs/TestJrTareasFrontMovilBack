import 'package:go_router/go_router.dart';
import 'package:sistema_ventas_app_v1/src/routes/app_routes.dart';
import 'package:sistema_ventas_app_v1/src/ui/pages/historial-venta/historial_venta_page.dart';
final List<GoRoute> historialRoutes = [
  GoRoute(
    path: AppRoutes.historial,
    builder: (context, state) => HistorialVentaPage(
    
    
    ),
  ),
];
