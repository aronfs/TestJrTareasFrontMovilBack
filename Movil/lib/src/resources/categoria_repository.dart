import 'dart:async';
import 'package:sistema_ventas_app_v1/src/models/categoria_model.dart';
import 'package:sistema_ventas_app_v1/src/resources/categoria_api_provider.dart';

class CategoriaRepository {
  final CategoriaApiProvider _categoriaApiProvider = CategoriaApiProvider();

  //Devuelve el listado de usuarios 
  Future<List<CategoriaModel>> fetchCategorias(String token) async {
    return await _categoriaApiProvider.fetchCategoria(token);
  }

  
}