import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' show Client;
import '../models/menu_model.dart';
import 'package:sistema_ventas_app_v1/src/utility/api_endpoints.dart';

class MenuApiProvider {
  final Client client = Client();

  // Método para obtener la lista de menús con el idUsuario
  Future<List<MenuModel>> fetchMenus(String token, int idUsuario) async {
    try {
      final uri = Uri.parse('${ApiEndpoints.getListaMenu}?idUsuario=$idUsuario');
      
      final response = await client.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token', // Autorización
        },
      );

      print('📄 Cuerpo de la respuesta: ${response.body}');
      if (response.statusCode == 200) {
        final jsondata = json.decode(response.body);

        // Validamos la estructura del body
        if (jsondata['status'] == true && jsondata['value'] is List) {
          return (jsondata['value'] as List)
              .map((item) => MenuModel.fromJson(item))
              .toList();
        }
      } else {
        print('❌ Error en la respuesta de la API: ${response.statusCode}');
        throw Exception('Failed to load menus');
      }
    } catch (e) {
      print('❌ Excepción al conectar con el servidor: $e');
      throw Exception('Excepción al conectar con el servidor: $e');
    }
    throw Exception('Unexpected error occurred');
  }
}

// Crear una instancia
final menuApiProvider = MenuApiProvider();
