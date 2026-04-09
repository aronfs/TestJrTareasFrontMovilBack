import 'dart:async';
import 'package:http/http.dart' show Client, Response;
import 'package:sistema_ventas_app_v1/src/utility/api_endpoints.dart';
import 'dart:convert';
import '../models/usuario_model.dart';

class UsuarioApiProvider {
  final Client client = Client();

  // Método para manejar las respuestas de la API
  Future<Map<String, dynamic>> _handleResponse(Response response) async {
    try {
      final responseData = json.decode(response.body);
      if (response.statusCode == 200 && responseData['status'] == true) {
        return responseData;
      } else {
        throw Exception('Error en la respuesta de la API: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error al procesar la respuesta: $e');
    }
  }

  // Método para obtener la lista de usuarios
  Future<List<UsuarioModel>> fetchUsuarios(String token) async {
    try {
      final response = await client.get(
        Uri.parse(ApiEndpoints.getUsuario),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      final responseData = await _handleResponse(response);

      // Mapear la lista de usuarios a objetos UsuarioModel
      return (responseData['value'] as List)
          .map((item) => UsuarioModel.fromJson(item))
          .toList();
    } catch (e) {
      print('Error al obtener usuarios: $e');
      rethrow;
    }
  }

  // Crear un nuevo usuario
  Future<bool> crearUsuario(String token, UsuarioModel usuario) async {
    try {
      final response = await client.post(
        Uri.parse(ApiEndpoints.saveUsuario),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(usuario.toJson()),
      );

      final responseData = await _handleResponse(response);

      return responseData['status'] == true;
    } catch (e) {
      print('Error al crear usuario: $e');
      return false;
    }
  }

  // Actualizar usuario existente
  Future<bool> actualizarUsuario(String token, UsuarioModel usuario) async {
    try {
      final response = await client.put(
        Uri.parse(ApiEndpoints.updateUsuario),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(usuario.toJson()),
      );

      final responseData = await _handleResponse(response);

      return responseData['status'] == true;
    } catch (e) {
      print('Error al actualizar usuario: $e');
      return false;
    }
  }

  // Eliminar un usuario
  Future<bool> eliminarUsuario(String token, int id) async {
    try {
      final response = await client.delete(
        Uri.parse('${ApiEndpoints.deleteUsuario}/$id'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      final responseData = await _handleResponse(response);

      return responseData['status'] == true;
    } catch (e) {
      print('Error al eliminar usuario: $e');
      return false;
    }
  }
}

// Crear una instancia global si es necesario
final usuarioApiProvider = UsuarioApiProvider();
