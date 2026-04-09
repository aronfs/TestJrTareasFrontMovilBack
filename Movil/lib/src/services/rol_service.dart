import 'package:flutter/widgets.dart';
import 'package:sistema_ventas_app_v1/src/blocs/rol_bloc/rol_bloc.dart';
import 'package:sistema_ventas_app_v1/src/utility/session_manager.dart';

class RolService {
  final SessionManager _sessionManager = SessionManager();
  final RolBloc _rolBloc = rolBloc;

  // Cargamos los roles desde el BLoC
  Future<void> cargarRoles(BuildContext context) async {
    await _sessionManager.init();
    try {
      final token = _sessionManager.token;
      if (token == null || token.isEmpty) {
        print("❌ No se encontró el token");
        return;
      }

      // Cargar los roles desde la API
      await _rolBloc.cargarRoles(token);

      // Escuchar los roles (una vez)
      _rolBloc.rol.first.then((roles) {
        if (roles.isNotEmpty) {
          print('✅ Roles cargados: ${roles.length}');
        } else {
          print('❌ No se encontraron roles.');
        }
      }).catchError((error) {
        print('❌ Error al obtener los roles: $error');
      });
    } catch (e) {
      print('❌ Error al cargar el rol BLoC: $e');
    }
  }
}
