import 'package:sistema_ventas_app_v1/src/blocs/menu_bloc/menu_bloc.dart';
import 'package:sistema_ventas_app_v1/src/utility/session_manager.dart';

class MainService {
  final SessionManager _sessionManager = SessionManager();

  Future<void> CargarMenusConDatosUsuario() async {
    // Asegúrate de inicializar el SessionManager antes de acceder a los datos
    await _sessionManager.init();

    final token = _sessionManager.token; // Obtiene el token
    final correo = _sessionManager.correo; // Obtiene el correo

    if (token != null && correo != null) {
      menuBloc.fetchUsuario(token, correo); // Cargar los menús dinámicos
      print('✅ Usuario autenticado: $correo');
    } else {
      print('⚠️ No se encontraron token o correo.');
    }
  }
}
