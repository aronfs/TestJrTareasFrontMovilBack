import 'package:flutter/material.dart';
import 'package:sistema_ventas_app_v1/src/routes/app_router.dart';
import 'package:sistema_ventas_app_v1/src/routes/app_routes.dart';
import 'package:sistema_ventas_app_v1/src/theme/app_theme.dart';
import 'package:sistema_ventas_app_v1/src/utility/navigation_service.dart';
import 'package:sistema_ventas_app_v1/src/utility/session_manager.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final SessionManager _sessionManager = SessionManager();

  @override
  void initState() {
    super.initState();
    _initializeSession();
  }

  Future<void> _initializeSession() async {
    await _sessionManager.init();

    if (!_sessionManager.isAuthenticated) {
      NavigationService().goToPath(AppRoutes.login);
    }
  }

  @override
  void dispose() {
    _sessionManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Aureo Workspace',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: router,
    );
  }
}
