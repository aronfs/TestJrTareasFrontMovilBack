import 'dart:async';
import 'package:sistema_ventas_app_v1/src/models/menu_model.dart';
import 'package:sistema_ventas_app_v1/src/resources/menu_api_provider.dart';


class MenuRepository {

  final menuApiProvider = MenuApiProvider();

 //Devuelve el listado de menus 
  Future<List<MenuModel>> fetchMenus(String token, int idUsuario) async {
    return await menuApiProvider.fetchMenus(token, idUsuario);
  }

}