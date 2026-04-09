import 'dart:async';

import 'package:sistema_ventas_app_v1/src/models/rol_model.dart';
import 'package:sistema_ventas_app_v1/src/resources/rol_api_provider.dart';

class RolRepository {
  final rolApiProvider = RolApiProvider();

  //Devolver la super lista de roles
  Future<List<RolModel>> fetchRol(String token)async{
    return rolApiProvider.fetchRoles(token);

  }
}