import 'dart:async';
import 'package:sistema_ventas_app_v1/src/models/dashboard_model.dart';
import 'package:sistema_ventas_app_v1/src/resources/dashboard_api_provider.dart';


class DashboardRepository {

  final dashboardApiProvider = DashboardApiProvider();


 //Devuelve el listado de menus 
  Future<List<DashBoardModel>> fetchDashboard(String token) async {
    return await dashboardApiProvider.fetchDashboard(token);
  }

}