import 'package:flutter/material.dart';
import 'package:sistema_ventas_app_v1/src/blocs/tareas_bloc/tareas_bloc.dart';
import 'package:sistema_ventas_app_v1/src/models/tareas_model.dart';
import 'package:sistema_ventas_app_v1/src/utility/jwt_utility.dart';
import 'package:sistema_ventas_app_v1/src/utility/session_manager.dart';

class TareaService {
  final TareasBloc _tareaBloc = tareasBloc;
  final SessionManager _sessionManager = SessionManager();
  final SessionManager sessionManager = SessionManager();
  List<Tareas> _tareas = [];

  void _mostrarMensaje(BuildContext context, String mensaje) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(mensaje)));
  }

  Future<List<Tareas>> cargarTareas(BuildContext context) async {
    await _sessionManager.init();
    try {
      final token = _sessionManager.token;
      if (token == null || token.isEmpty) {
        print('No se encontro el token.');
        _mostrarMensaje(context, 'Token no encontrado');
        return [];
      }

      final correo = JwtUtils.obtenerCorreoDesdeToken(token);
      if (correo == null) {
        print('No se pudo extraer el correo del token.');
      }

      _tareas = await _tareaBloc.cargarTareas(token, correo);
      if (_tareas is List<dynamic>) {
        print('Tareas cargadas');
      } else {
        print('No se encontraron tareas');
      }

      return _tareas;
    } catch (e) {
      print('Error al cargar tareas: $e');
      _mostrarMensaje(context, 'Error al cargar tareas');
      return [];
    }
  }

  Future<void> guardarTarea({
    required BuildContext context,
    required GlobalKey<FormState> formKey,
    required String tituloTarea,
    required String descripcionTarea,
    required String comentarioTarea,
  }) async {
    await _sessionManager.init();
    try {
      if (!formKey.currentState!.validate()) return;

      final token = _sessionManager.token;
      if (token == null || token.isEmpty) {
        print('No se encontro el token.');
        return;
      }

      final usuarioId = int.tryParse(JwtUtils.obtnereIDUserToken(token));
      final tareaNueva = Tareas(
        idTarea: 0,
        tituloTarea: tituloTarea.trim(),
        descripcion: descripcionTarea.trim(),
        comentario: comentarioTarea.trim(),
        idUsuario: usuarioId,
      );

      final resultado = await _tareaBloc.crearTarea(token, tareaNueva);

      if (resultado) {
        await cargarTareas(context);
        _mostrarMensaje(context, 'Tarea creada exitosamente');
        Navigator.pop(context);
      } else {
        _mostrarMensaje(context, 'Error al crear la tarea');
      }
    } catch (e) {
      print('Error al crear tarea: $e');
      _mostrarMensaje(context, 'Error al crear la tarea');
    }
  }

  Future<void> actualizartarea({
    required BuildContext context,
    required GlobalKey<FormState> formKey,
    required int idTarea,
    required int? idUsuario,
    required String tituloTarea,
    required String descripcionTarea,
    required String comentarioTarea,
  }) async {
    await _sessionManager.init();
    try {
      if (!formKey.currentState!.validate()) return;

      final token = _sessionManager.token;
      if (token == null || token.isEmpty) {
        print('No se encontro el token.');
        return;
      }

      final usuarioIdToken = int.tryParse(JwtUtils.obtnereIDUserToken(token));
      final tareaActualizada = Tareas(
        idTarea: idTarea,
        tituloTarea: tituloTarea.trim(),
        descripcion: descripcionTarea.trim(),
        comentario: comentarioTarea.trim(),
        idUsuario: idUsuario ?? usuarioIdToken,
      );

      final resultado = await _tareaBloc.actualizarTarea(
        token,
        tareaActualizada,
      );

      if (resultado) {
        await cargarTareas(context);
        _mostrarMensaje(context, 'Tarea actualizada exitosamente');
        Navigator.pop(context);
      } else {
        _mostrarMensaje(context, 'Error al actualizar la tarea');
      }
    } catch (e) {
      print('Error al actualizar tarea: $e');
      _mostrarMensaje(context, 'Error al actualizar la tarea');
    }
  }

  Future<void> inactivarTarea({
    required BuildContext context,
    required int? idTarea,
  }) async {
    await sessionManager.init();
    final token = sessionManager.token;

    if (token == null || token.isEmpty) {
      print('No se encontro el token.');
      return;
    }

    try {
      final inactivar = await _tareaBloc.inactivarTarea(token, idTarea);
      if (inactivar) {
        await cargarTareas(context);
        _mostrarMensaje(context, 'Tarea eliminada exitosamente');
      } else {
        _mostrarMensaje(context, 'Error al eliminar la tarea');
      }
    } catch (e) {
      print('Error al eliminar tarea: $e');
      _mostrarMensaje(context, 'Ocurrio un error al eliminar la tarea');
    }
  }

  Future<void> completearTarea({
    required BuildContext context,
    required int? idTarea,
  }) async {
    await sessionManager.init();
    final token = sessionManager.token;

    if (token == null || token.isEmpty) {
      print('No se encontro el token.');
      return;
    }

    try {
      final completar = await _tareaBloc.completarTarea(token, idTarea);
      if (completar) {
        await cargarTareas(context);
        _mostrarMensaje(context, 'Tarea completada exitosamente');
      } else {
        _mostrarMensaje(context, 'Error al completar la tarea');
      }
    } catch (e) {
      print('Error al completar tarea: $e');
      _mostrarMensaje(context, 'Ocurrio un error al completar la tarea');
    }
  }
}
