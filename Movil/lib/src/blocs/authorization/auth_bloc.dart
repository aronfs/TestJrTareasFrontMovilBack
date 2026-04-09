import 'package:sistema_ventas_app_v1/src/utility/jwt_utility.dart';
import 'package:sistema_ventas_app_v1/src/utility/session_manager.dart';
import '../../resources/auth_repository.dart';
import 'package:rxdart/rxdart.dart';
import '../../models/auth_model.dart';

class AuthBloc {
  final _repository = Repository();
  final _sessionManager = SessionManager();
  bool hasTriedLogin = false;

  // Controla si el usuario está autenticado
  final _isAuthenticatedController = BehaviorSubject<bool>.seeded(false);
  Stream<bool> get isAuthenticated => _isAuthenticatedController.stream;

  // Controla el estado de carga
  final _isLoadingController = BehaviorSubject<bool>.seeded(false);
  Stream<bool> get isLoading => _isLoadingController.stream;

  // Controla el token actual
  final _tokenController = BehaviorSubject<String?>();
  Stream<String?> get token => _tokenController.stream;

  // ✅ Nuevo: Controla el correo actual
  final _correoController = BehaviorSubject<String?>();
  Stream<String?> get correo => _correoController.stream;

  AuthBloc() {
    _loadSession();
  }

  // ✅ Cargar la sesión almacenada (token y correo)
  Future<void> _loadSession() async {
    try {
      await _sessionManager.init();
      final storedToken = _sessionManager.token;
      final storedCorreo = _sessionManager.correo;

      if (storedToken != null && storedCorreo != null) {
        _tokenController.sink.add(storedToken);
        _correoController.sink.add(storedCorreo);
        _isAuthenticatedController.sink.add(true);
      }
    } catch (e) {
      print('❌ Error al cargar la sesión: $e');
    }
  }

  // ✅ Limpiar la sesión (logout)
  Future<void> clearSession() async {
    try {
      await _sessionManager.clearSession();
      _tokenController.sink.add(null);
      _correoController.sink.add(null);
      _isAuthenticatedController.sink.add(false);
    } catch (e) {
      print('❌ Error al limpiar la sesión: $e');
    }
  }

  // ✅ Autenticar y guardar la sesión (token y correo)
  Future<void> fetchToken(AuthModel authModel) async {
    try {
      _isLoadingController.sink.add(true);
      final auth = await _repository.fetchToken(authModel);

      if (auth.token != null && auth.token!.isNotEmpty) {
        // Obtener el correo del token o del backend
        final email = auth.email ?? JwtUtils.obtenerCorreoDesdeToken(auth.token!);

        if (email != null) {
          await _sessionManager.updateSession(auth.token!, email);
          _tokenController.sink.add(auth.token!);
          _correoController.sink.add(email);
          _isAuthenticatedController.sink.add(true);
          print('📧 Correo decodificado: $email');
        } else {
          print('⚠️ No se pudo extraer el correo.');
          _isAuthenticatedController.sink.add(false);
        }
      } else {
        print('❌ Token inválido o vacío.');
        _isAuthenticatedController.sink.add(false);
      }
    } catch (e) {
      print('❌ Error en fetchToken: $e');
      _isAuthenticatedController.sink.add(false);
    } finally {
      _isLoadingController.sink.add(false);
    }
  }

  // ✅ Limpia los streams
  void dispose() {
    _isAuthenticatedController.close();
    _isLoadingController.close();
    _tokenController.close();
    _correoController.close();
  }
}

// ✅ Instancia global del AuthBloc
final authBloc = AuthBloc();
