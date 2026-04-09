import 'dart:async';
import '../models/usuario_model.dart';
import 'usuario_api_provider.dart';

class UsuarioRepository {
  final UsuarioApiProvider _usuarioApiProvider = UsuarioApiProvider();

  //Devuelve el listado de usuarios 
  Future<List<UsuarioModel>> fetchUsuario(String token) async {
    return await _usuarioApiProvider.fetchUsuarios(token);
  }

  Future<bool> saveUsuario(UsuarioModel usuario, String token) async {
    return await _usuarioApiProvider.crearUsuario(token, usuario);
  }

  Future<bool> updateUsuario(String token,UsuarioModel usuario,) async {
    return await _usuarioApiProvider.actualizarUsuario(token, usuario);
  }

  Future<bool> deleteUsuario(int idUsuario, String token) async {
    return await _usuarioApiProvider.eliminarUsuario(token,idUsuario);
  }
}
