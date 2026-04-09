import 'dart:async';
import 'package:http/http.dart' show Client, Response;
import 'package:sistema_ventas_app_v1/src/models/producto_model.dart';
import 'package:sistema_ventas_app_v1/src/utility/api_endpoints.dart';
import 'dart:convert';

class ProductoApiProvider {
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
  Future<List<ProductoModel>> fetchProductos(String token) async {
    try {
      final response = await client.get(
        Uri.parse(ApiEndpoints.getProducto),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      final responseData = await _handleResponse(response);

      // Mapear la lista de usuarios a objetos UsuarioModel
      return (responseData['value'] as List)
          .map((item) => ProductoModel.fromJson(item))
          .toList();
    } catch (e) {
      print('Error al obtener usuarios: $e');
      rethrow;
    }
  }

  // Crear un nuevo usuario
  Future<bool> crearProducto(String token, ProductoModel producto) async {
    try {
      final response = await client.post(
        Uri.parse(ApiEndpoints.saveProducto),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(producto.toJson()),
      );

      final responseData = await _handleResponse(response);

      return responseData['status'] == true;
    } catch (e) {
      print('Error al crear producto: $e');
      return false;
    }
  }

  // Actualizar usuario existente
  Future<bool> actualizarProducto(String token, ProductoModel producto) async {
    try {
      final response = await client.put(
        Uri.parse(ApiEndpoints.updateProducto),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(producto.toJson()),
      );

      final responseData = await _handleResponse(response);

      return responseData['status'] == true;
    } catch (e) {
      print('Error al actualizar producto: $e');
      return false;
    }
  }

  // Eliminar un usuario
  Future<bool> eliminarProducto(String token, int id) async {
    try {
      final response = await client.delete(
        Uri.parse('${ApiEndpoints.deleteProducto}/$id?'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
     

      final responseData = await _handleResponse(response);
      print('${ApiEndpoints.deleteProducto}/$id''$responseData');
      return responseData['status'] == true;
    } catch (e) {
      print('Error al eliminar producto: $e');
      
      return false;
    }
  }
}

// Crear una instancia global si es necesario
final productoApiProvider = ProductoApiProvider();
