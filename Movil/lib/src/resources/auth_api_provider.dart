import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/auth_model.dart';
import 'package:sistema_ventas_app_v1/src/utility/api_endpoints.dart';

class AuthApiProvider {
  final http.Client client;

  // Constructor
  AuthApiProvider({http.Client? client}) : client = client ?? http.Client();

  // Función para obtener el token
  Future<AuthModel> fetchToken(AuthModel authModel) async {
    try {
      final response = await client.post(
        Uri.parse(ApiEndpoints.login),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': authModel.email,
          'password': authModel.password,
        }),
      );

      // Verificamos si la respuesta fue exitosa (status code 200)
      if (response.statusCode == 200) {
        // Devolvemos el modelo a partir de la respuesta en formato JSON
        return AuthModel.fromJson(json.decode(response.body));
      } else {
        // En caso de error, mostrar el status code y la respuesta
        print('Error: Status Code ${response.statusCode}');
        return AuthModel(); // Retornamos un modelo vacío en caso de error
      }
    } catch (e) {
      // Manejo de excepciones (errores de red, etc.)
      print('Error al obtener el token: $e');
      return AuthModel(); // Retornamos un modelo vacío si ocurre un error
    }
  }
}
