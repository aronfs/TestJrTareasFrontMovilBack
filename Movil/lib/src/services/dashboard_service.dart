import 'package:flutter/material.dart';
import 'package:sistema_ventas_app_v1/src/blocs/dashboard_bloc/dashboard_bloc.dart';
import 'package:sistema_ventas_app_v1/src/models/dashboard_model.dart';
import 'package:sistema_ventas_app_v1/src/utility/session_manager.dart';

class DashboardService {
  final DashboardBloc _dashboardBloc = dashboardBloc;
  List<DashBoardModel> _dashboard = [];
  final SessionManager _sessionManager = SessionManager();

  void _mostrarMensaje(BuildContext context, String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mensaje)));
  }
  Future<List<DashBoardModel>> cargarDashboard(BuildContext context) async {
    await _sessionManager.init();
    try{
 final token = _sessionManager.token;
      if (token == null || token.isEmpty) {
        print('⚠️ No se encontró el token.');
        _mostrarMensaje(context, 'Token no encontrado');
        return [];
      }

      //Cargar el dashboard

      _dashboard = await _dashboardBloc.fetchDashboard(token);
      return _dashboard;
    }catch(e){
      print('❌ Error al cargar productos con categorías: $e');
      _mostrarMensaje(context, 'Error al cargar productos con categorías.');
      return [];
    }
  }




}