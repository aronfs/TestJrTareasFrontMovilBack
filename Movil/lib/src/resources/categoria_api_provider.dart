import 'dart:async';
import 'package:http/http.dart' show Client, Response;
import 'package:sistema_ventas_app_v1/src/models/categoria_model.dart';
import 'package:sistema_ventas_app_v1/src/utility/api_endpoints.dart';
import 'dart:convert';

class CategoriaApiProvider {
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
  Future<List<CategoriaModel>> fetchCategoria(String token) async {
    try {
      final response = await client.get(
        Uri.parse(ApiEndpoints.getCategoria),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      final responseData = await _handleResponse(response);

      // Mapear la lista de usuarios a objetos UsuarioModel
      return (responseData['value'] as List)
          .map((item) => CategoriaModel.fromJson(item))
          .toList();
    } catch (e) {
      print('Error al obtener categorias: $e');
      rethrow;
    }
  }
 
}

// Crear una instancia global si es necesario
final categoriaApiProvider = CategoriaApiProvider();
