import 'package:go_router/go_router.dart';
import 'package:sistema_ventas_app_v1/src/models/producto_model.dart';
import 'package:sistema_ventas_app_v1/src/routes/app_routes.dart';
import 'package:sistema_ventas_app_v1/src/ui/forms/producto_form.dart';
import 'package:sistema_ventas_app_v1/src/ui/pages/producto/productos_page.dart';

final List<GoRoute> productosRoutes= [
  GoRoute(
    path: AppRoutes.productos,
    builder: (context, state) => ProductosPage(),
  ),
  GoRoute(
    path: AppRoutes.productoForm,
    builder: (context, state) {
      final producto = state.extra as ProductoModel?;
      return ProductoForm(producto: producto); // Pasa el usuario al formulario
    },
  ),
];