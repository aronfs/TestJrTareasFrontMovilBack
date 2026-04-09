
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sistema_ventas_app_v1/src/blocs/authorization/auth_bloc.dart';
import 'package:sistema_ventas_app_v1/src/models/auth_model.dart';
import 'package:sistema_ventas_app_v1/src/routes/app_routes.dart';
import 'package:sistema_ventas_app_v1/src/ui/dialogs/custom_snackbar.dart';
import 'package:sistema_ventas_app_v1/src/utility/navigation_service.dart';
import 'package:sistema_ventas_app_v1/src/utility/session_manager.dart';
class AuthService {
  final AuthBloc _authBloc = authBloc; // Inyecta el AuthBloc
  final SessionManager _sessionManager = SessionManager();
  StreamSubscription<bool>? _authSubscription;
  StreamSubscription<String?>? _tokenSubscription;
  Future<void> initAuthListener(BuildContext context) async {
    // Inicializar el SessionManager
    await _sessionManager.init();
    // Cancelar suscripciones anteriores si existen
    _authSubscription?.cancel();
    _tokenSubscription?.cancel();
    _authSubscription = _authBloc.isAuthenticated.listen((isAuthenticated) async {
      if (isAuthenticated) {
        // Escuchar el token y el correo para actualizar la sesión
        _tokenSubscription = _authBloc.token.listen((token) async {
          final correo = await _authBloc.correo.firstWhere((correo) => correo != null, orElse: () => null);
          if (token != null && correo != null) {
            await _sessionManager.updateSession(token, correo);
            print("✅ Sesión actualizada: Token y correo válidooos.$token$correo");
          } else {
            print("❌ No se encontraron tokeneswwwww o correo.");
          }
        });
        CustomSnackBar.show(context, '¡Inicio de sesión exitoso!', Colors.green);
        navigationService.goToPath(AppRoutes.mainScreen);
      } else {
        if (_authBloc.hasTriedLogin) {
          CustomSnackBar.show(context, 'Credenciales incorrectas.', Colors.red);
        }
      }
    });
  }
  void validateAndLogin(BuildContext context, AuthModel authModel) {
    if ((authModel.email?.isEmpty ?? true) || (authModel.password?.isEmpty ?? true)) {
      CustomSnackBar.show(context, 'Por favor, complete todos los campos.', Colors.orange);
      return;
    }
    _authBloc.hasTriedLogin = true; // Marcar intento de inicio de sesión
    _authBloc.fetchToken(authModel); // Inicia la autenticación
  }
  Future<void> logout(BuildContext context) async {
    await _authBloc.clearSession(); // Limpia el estado del BLoC
    await _sessionManager.clearSession(); // Limpia la sesión almacenada
    // Limpiar suscripciones para evitar fugas de memoria
    _authSubscription?.cancel();
    _tokenSubscription?.cancel();
    CustomSnackBar.show(context, 'Sesión cerrada.', Colors.blue);
    navigationService.goToPath(AppRoutes.login); // Redirige al login
  }
}
