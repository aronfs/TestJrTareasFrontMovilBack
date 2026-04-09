import 'dart:async';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sistema_ventas_app_v1/src/routes/app_routes.dart';
import 'package:sistema_ventas_app_v1/src/utility/navigation_service.dart';

class SessionManager with WidgetsBindingObserver {
  static const String _tokenKey = 'auth_token';
  static const String _correoKey = 'user_email';

  Timer? _inactivityTimer;

  // ✅ Almacena el token y correo en memoria
  String? _token;
  String? _correo;

  // Getters para acceder a los valores
  String? get token => _token;
  String? get correo => _correo;

  // Duración antes de cerrar la sesión por inactividad
  final Duration sessionDuration = const Duration(minutes: 60);

  // ✅ Inicializa el SessionManager y carga la sesión
  Future<void> init() async {
    WidgetsBinding.instance.addObserver(this);
    await _loadSession();
    if (_token == null || _token!.isEmpty) {
      NavigationService().goToPath(AppRoutes.login);  // Si no hay sesión, redirigir al login
    } else {
      _resetInactivityTimer();
    }
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _inactivityTimer?.cancel();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _checkAndLogout();  // Cerrar sesión si la app se pausa
    } else if (state == AppLifecycleState.resumed) {
      _resetInactivityTimer();  // Reiniciar temporizador cuando la app se reanuda
    }
  }

  // ✅ Carga el token y correo desde SharedPreferences
  Future<void> _loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString(_tokenKey);
    _correo = prefs.getString(_correoKey);
    print("📌 Sesión cargada: Token: $_token, Correo: $_correo");
  }

  // ✅ Reinicia el temporizador de inactividad
  void _resetInactivityTimer() {
    _inactivityTimer?.cancel();
    _inactivityTimer = Timer(sessionDuration, _checkAndLogout);
  }

  // ✅ Cierra sesión si el token es inválido o si ha expirado
  Future<void> _checkAndLogout() async {
    if (_token == null || _token!.isEmpty || _isTokenExpired(_token!)) {
      await clearSession();
      NavigationService().goToPath(AppRoutes.login);
      print("✅ Sesión cerrada automáticamente.");
    }
  }

  // ✅ Verifica si el token ha expirado
  bool _isTokenExpired(String token) {
    return JwtDecoder.isExpired(token);
  }

  // ✅ Actualiza el token y correo en memoria y almacenamiento
  Future<void> updateSession(String token, String correo) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_correoKey, correo);
    _token = token;
    _correo = correo;
    print("🔐 Sesión actualizada: Token: $_token, Correo: $_correo");
    _resetInactivityTimer();
  }

  // ✅ Limpia el token y correo en memoria y almacenamiento
  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_correoKey);
    _token = null;
    _correo = null;
    _inactivityTimer?.cancel();
    print("🚪 Sesión limpiada.");
  }

  // ✅ Verifica si el usuario está autenticado
  bool get isAuthenticated => _token != null && _correo != null;
}
