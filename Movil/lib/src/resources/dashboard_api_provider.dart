import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' show Client;
import 'package:sistema_ventas_app_v1/src/models/dashboard_model.dart';
import 'package:sistema_ventas_app_v1/src/utility/api_endpoints.dart';

class DashboardApiProvider {
  final Client client = Client();

  Future<List<DashBoardModel>> fetchDashboard(String token) async {
    try {
      final uri = Uri.parse(ApiEndpoints.dashboard);
      final response = await client.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      print('📄 Cuerpo de la respuesta: ${response.body}');

      if (response.statusCode == 200) {
        final jsondata = json.decode(response.body);

        if (jsondata['status'] == true && jsondata['value'] is Map) {
          return [DashBoardModel.fromJson(jsondata['value'])]; // Convertimos en una lista
        } else {
          throw Exception('Formato de JSON inesperado');
        }
      } else {
        print('❌ Error en la API: ${response.statusCode}');
        throw Exception('Error al cargar el dashboard');
      }
    } catch (e) {
      print('❌ Excepción: $e');
      throw Exception('Error al conectar con el servidor: $e');
    }
  }
}
