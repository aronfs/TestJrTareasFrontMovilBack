import 'package:flutter/material.dart';
import 'package:sistema_ventas_app_v1/src/models/auth_model.dart';
import 'package:sistema_ventas_app_v1/src/services/auth_service.dart';
import 'package:sistema_ventas_app_v1/src/theme/app_theme.dart';
import 'package:sistema_ventas_app_v1/src/ui/widgets/Login_widgets/button_session_start_login.dart';
import 'package:sistema_ventas_app_v1/src/ui/widgets/Login_widgets/email_field.dart';
import 'package:sistema_ventas_app_v1/src/ui/widgets/Login_widgets/password_field.dart';

class AuthLogin extends StatefulWidget {
  const AuthLogin({super.key});

  @override
  State<AuthLogin> createState() => _AuthLoginState();
}

class _AuthLoginState extends State<AuthLogin> {
  final AuthModel authModel = AuthModel();
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _authService.initAuthListener(context);
  }

  void _validateAndLogin() {
    _authService.validateAndLogin(context, authModel);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF16343D), Color(0xFF255968), Color(0xFFE7D7B4)],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: -80,
              right: -30,
              child: Container(
                width: 220,
                height: 220,
                decoration: const BoxDecoration(
                  color: Color(0x1AFFF6E5),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              bottom: -40,
              left: -50,
              child: Container(
                width: 180,
                height: 180,
                decoration: const BoxDecoration(
                  color: Color(0x14FFFFFF),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 440),
                  child: Container(
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: AppTheme.paper.withOpacity(0.92),
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(color: const Color(0xFFF6E8CB)),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x3312323B),
                          blurRadius: 28,
                          offset: Offset(0, 18),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 72,
                          width: 72,
                          decoration: const BoxDecoration(
                            color: Color(0xFFE7D7B4),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.fact_check_rounded,
                            size: 34,
                            color: AppTheme.ink,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Aureo Workspace',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Una experiencia mas limpia para organizar trabajo, tareas y operaciones del dia.',
                          style: TextStyle(color: AppTheme.muted, height: 1.5),
                        ),
                        const SizedBox(height: 28),
                        Text(
                          'Iniciar sesion',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Ingresa con tus credenciales y continua donde lo dejaste.',
                          style: TextStyle(color: AppTheme.muted),
                        ),
                        const SizedBox(height: 18),
                        EmailField(onChanged: (value) => authModel.email = value),
                        const SizedBox(height: 16),
                        PasswordField(
                          onChanged: (value) => authModel.password = value,
                        ),
                        const SizedBox(height: 20),
                        SubmitButton(onPressed: _validateAndLogin),
                        const SizedBox(height: 18),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.verified_user_outlined,
                              size: 16,
                              color: AppTheme.muted,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Acceso seguro y sincronizado',
                              style: TextStyle(color: AppTheme.muted),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
