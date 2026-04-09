import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' show Client;
import '../models/rol_model.dart';
import 'package:sistema_ventas_app_v1/src/utility/api_endpoints.dart';

class RolApiProvider {
  final Client client = Client();
  
  //Metodo para obtener la lista de rol 
  Future<List<RolModel>> fetchRoles(String token)async{
    try{
      final uri = Uri.parse(ApiEndpoints.getRoles);

      final response = await client.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
        } 
        );

    if(response.statusCode == 200){
      final jsondata = json.decode(response.body);
      if(jsondata['status'] == true && jsondata['value'] is List){
        return (jsondata['value'] as List)
              .map((item) => RolModel.fromJson(item))
              .toList();
      }
    }else {
      print('❌ Error en la respuesta de la API: ${response.statusCode}');
        throw Exception('Failed to load menus');
    }


    }catch (e){
        throw Exception('Excepción al conectar con el servidor: $e');
    } 
    throw Exception('Unexpected error occurred');
  }
}