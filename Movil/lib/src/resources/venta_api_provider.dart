import 'dart:async';
import 'package:http/http.dart' show Client, Response;
import 'package:sistema_ventas_app_v1/src/models/reporte_model.dart';
import 'package:sistema_ventas_app_v1/src/models/venta_model.dart';
import 'package:sistema_ventas_app_v1/src/utility/api_endpoints.dart';
import 'dart:convert';


class VentaApiProvider {
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



  Future<List<ReporteModel>> reporte(String token, String fechaInicio, String fechaFin ) async {
    try {
      final response = await client.get(
         Uri.parse('${ApiEndpoints.reporte}?fechaInicio=$fechaInicio&fechaFin=$fechaFin'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      final responseData = await _handleResponse(response);

      // Mapear la lista de usuarios a objetos UsuarioModel
      return (responseData['value'] as List)
          .map((item) => ReporteModel.fromJson(item))
          .toList();
    } catch (e) {
      print('Error al obtener reporte: $e');
      rethrow;
    }
  }




  // Método para obtener el historial de las ventas
  Future<List<VentaModel>> historial(String token, String filtro, String numeroVenta, String fechaInicio, String fechaFin ) async {
    try {
      final response = await client.get(
      Uri.parse('${ApiEndpoints.historial}?buscarPro=$filtro&numeroVenta=$numeroVenta&fechaInicio=$fechaInicio&fechaFin=$fechaFin'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      final responseData = await _handleResponse(response);

      // Mapear la lista de usuarios a objetos UsuarioModel
      return (responseData['value'] as List)
          .map((item) => VentaModel.fromJson(item))
          .toList();
    } catch (e) {
      print('Error al obtener usuarios: $e');
      rethrow;
    }
  }


  // Crear un nuevo usuario
  Future<bool> registrarVenta(String token, VentaModel venta) async {
    try {
      final response = await client.post(
        Uri.parse(ApiEndpoints.registerVenta),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(venta.toJson()),
      );

      final responseData = await _handleResponse(response);

      return responseData['status'] == true;
    } catch (e) {
      print('Error al crear venta: $e');
      return false;
    }
  }



}

// Crear una instancia global si es necesario
final ventaApiProvider = VentaApiProvider();
