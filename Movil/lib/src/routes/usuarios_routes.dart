import 'package:go_router/go_router.dart';
import 'package:sistema_ventas_app_v1/src/routes/app_routes.dart';
import 'package:sistema_ventas_app_v1/src/ui/forms/usuario_form.dart';
import 'package:sistema_ventas_app_v1/src/ui/pages/usuarios/usuario_page.dart';
import 'package:sistema_ventas_app_v1/src/models/usuario_model.dart';

final List<GoRoute> usuarioRoutes = [
  GoRoute(
    path: AppRoutes.usuarios,
    builder: (context, state) => UsuarioPage(),
  ),
  GoRoute(
    path: AppRoutes.usuarioForm,
    builder: (context, state) {
      final usuario = state.extra as UsuarioModel?;
      return UsuarioForm(usuario: usuario); // Pasa el usuario al formulario
    },
  ),
];
