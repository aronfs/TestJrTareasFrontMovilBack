import 'package:flutter/material.dart';
import 'package:sistema_ventas_app_v1/src/blocs/usuario_bloc/usuario_bloc.dart';
import 'package:sistema_ventas_app_v1/src/models/usuario_model.dart';
import 'package:sistema_ventas_app_v1/src/utility/jwt_utility.dart';
import 'package:sistema_ventas_app_v1/src/utility/session_manager.dart';

class UsuarioService {
  final UsuarioBloc _usuarioBloc = usuarioBloc;
  final sessionManager = SessionManager(); // Usa la instancia global

  void _mostrarMensaje(BuildContext context, String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mensaje)));
  }

  Future<void> guardarUsuario({
    required BuildContext context,
    required GlobalKey<FormState> formKey,
    required String nombre,
    required String correo,
    required String clave,
    required int? selectedRole,
    required int? estadoSeleccionado,
    required String? fotoBase64,
  }) async {
    await sessionManager.init();
    if (!formKey.currentState!.validate()) return;

    if (selectedRole == null) {
      _mostrarMensaje(context, 'Seleccione un rol');
      return;
    }

    if (estadoSeleccionado == null) {
      _mostrarMensaje(context, 'Seleccione un estado');
      return;
    }

    final token = sessionManager.token;
    if (token == null || token.isEmpty) {
      print('⚠️ No se encontró el token.');
      return;
    }

    final nuevoUsuario = UsuarioModel(
      idUsuario: 0,
      nombreCompleto: nombre.trim(),
      correo: correo.trim(),
      clave: clave.trim(),
      idRol: selectedRole,
      esActivo: estadoSeleccionado,
      foto: fotoBase64,
    );

    try {
      final resultado = await _usuarioBloc.crearUsuario(token, nuevoUsuario);
      if (resultado) {
        _mostrarMensaje(context, 'Usuario creado exitosamente');
        Navigator.pop(context);
      } else {
        _mostrarMensaje(context, 'Error al crear el usuario');
      }
    } catch (e) {
      print('❌ Error al crear usuario: $e');
      _mostrarMensaje(context, 'Error al crear el usuario');
    }
  }

  Future<void> eliminarUsuario({
    required BuildContext context,
    required int idUsuario,
  }) async {
    await sessionManager.init();
    final token = sessionManager.token;

    if (token == null || token.isEmpty) {
      print('⚠️ No se encontró el token.');
      return;
    }

    try {
      final eliminado = await _usuarioBloc.eliminarUsuario(token, idUsuario);
      if (eliminado) {
        _mostrarMensaje(context, '✅ Usuario eliminado exitosamente');
      } else {
        _mostrarMensaje(context, '❌ Error al eliminar el usuario');
      }
    } catch (e) {
      print('❌ Error al eliminar usuario: $e');
      _mostrarMensaje(context, '❌ Ocurrió un error al eliminar el usuario');
    }
  }

  Future<void> actualizarUsuario({
    required BuildContext context,
    required GlobalKey<FormState> formKey,
    required String nombre,
    required String correo,
    required String clave,
    required int? selectedRole,
    required int? estadoSeleccionado,
    required String? fotoBase64,
    required int idUsuario,
  }) async {
    await sessionManager.init();
    if (!formKey.currentState!.validate()) return;

    if (selectedRole == null) {
      _mostrarMensaje(context, 'Seleccione un rol');
      return;
    }

    if (estadoSeleccionado == null) {
      _mostrarMensaje(context, 'Seleccione un estado');
      return;
    }

    final token = sessionManager.token;
    if (token == null || token.isEmpty) {
      print('⚠️ No se encontró el token.');
      return;
    }

    final usuarioActualizado = UsuarioModel(
      idUsuario: idUsuario,
      nombreCompleto: nombre,
      correo: correo,
      clave: clave,
      idRol: selectedRole,
      esActivo: estadoSeleccionado,
      foto: fotoBase64,
    );

    try {
      final resultado = await _usuarioBloc.actualizarUsuario(token, usuarioActualizado);
      if (resultado) {
        _mostrarMensaje(context, 'Usuario actualizado exitosamente');
        Navigator.pop(context);
      } else {
        _mostrarMensaje(context, 'Error al actualizar el usuario');
      }
    } catch (e) {
      print('❌ Error al actualizar usuario: $e');
      _mostrarMensaje(context, '❌ Error al actualizar el usuario');
    }
  }

  Future<void> CargarUsuarios(BuildContext context) async {
    await sessionManager.init();
    try {
      final token = sessionManager.token;
      if (token == null || token.isEmpty) {
        print('⚠️ No se encontró el token.');
        return;
      }

      final usuarios = await _usuarioBloc.cargarUsuarios(token);
      if (usuarios is List<dynamic> ) {
        // Actualiza la UI o maneja los datos aquí
        print('✅ Usuarios cargados');
      } else {
        print('❌ No se encontraron usuarios.');
      }
    } catch (e) {
      print('❌ Error al cargar usuarios: $e');
      _mostrarMensaje(context, '❌ Error al cargar usuarios');
    }
  }

  Future<void> initUsuarioListener(BuildContext context) async {
    await sessionManager.init();
    try {
      final token = sessionManager.token;
      if (token == null || token.isEmpty) {
        print('⚠️ No se encontró el token.');
        return;
      }

      final correo = JwtUtils.obtenerCorreoDesdeToken(token);
      if (correo == null) {
        print('❌ No se pudo extraer el correo del token.');
        return;
      }

      print('📧 Correo extraído del token: $correo');
      final usuario = await _usuarioBloc.fetchUsuario(token, correo);
      if (usuario is UsuarioModel) {
        print('✅ Usuario autenticado: $usuario');
      } else {
        print('❌ No se encontró el usuario o el tipo de dato es incorrecto.');
      }
    } catch (e) {
      print('❌ Error en initUsuarioListener: $e');
    }
  }
}
