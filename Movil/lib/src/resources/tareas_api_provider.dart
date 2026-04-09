


import 'dart:convert';

import 'package:http/http.dart';
import 'package:sistema_ventas_app_v1/src/models/tareas_model.dart';
import 'package:sistema_ventas_app_v1/src/utility/api_endpoints.dart';

class TareasApiProvider {
  final Client client = Client();

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


  Future<List<Tareas>> fetchTareas(String token, int? id) async {
    try{
      final response = await client.get(
        Uri.parse('${ApiEndpoints.gettareas}/$id?'),
        headers: {
           'Authorization': 'Bearer $token',
        }
      );

      final responseData = await _handleResponse(response);
      return (responseData['value'] as List)
        .map((item)=> Tareas.fromJson(item))
        .toList();
    }catch (e){
      print('Error al obtener tareas: $e');
      rethrow;
    }
  }

  Future<bool> crearTarea(String token, Tareas tarea) async { 
    try {
      final response = await  client.post(
        Uri.parse(ApiEndpoints.saveTarea),
        headers:  {
           'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(tarea.toJson())
      );
      final responseData = await _handleResponse(response);
      return responseData['status'] == true;

    } catch (e) {
      print('Error al crear la tarea: $e');
      return false;
    }
  }

  Future<bool> actualizarTarea(String token, Tareas tarea) async { 
    try { 
      final response = await client.put(
        Uri.parse(ApiEndpoints.updateTarea),
          headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(tarea.toJson()),
      );
      final responseData = await _handleResponse(response);

      return responseData['status'] == true;
      
    } catch (e) {
      print('Error al actualizar la tarea: $e');
      return false;
    }
  }


   Future<bool> completarTarea(String token, int? id) async { 
    try { 
      final response = await client.put(
        Uri.parse('${ApiEndpoints.completeTarea}/$id?'),
          headers: {
          'Authorization': 'Bearer $token',
        });
       
      final responseData = await _handleResponse(response);

      return responseData['status'] == true;
      
    } catch (e) {
      print('Error al actualizar la tarea: $e');
      return false;
    }
  }


   Future<bool> inactivarTarea(String token, int? id) async { 
    try { 
      final response = await client.put(
        Uri.parse('${ApiEndpoints.inactivarTarea}/$id?'),
          headers: {
         
          'Authorization': 'Bearer $token',
        },
        
      );
      final responseData = await _handleResponse(response);

      return responseData['status'] == true;
      
    } catch (e) {
      print('Error al actualizar la tarea: $e');
      return false;
    }
  }

}