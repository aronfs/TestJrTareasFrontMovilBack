import 'dart:async';
import 'package:sistema_ventas_app_v1/src/models/reporte_model.dart';
import 'package:sistema_ventas_app_v1/src/models/venta_model.dart';
import 'package:sistema_ventas_app_v1/src/resources/venta_api_provider.dart';


class VentaRepository {
  final VentaApiProvider _ventaApiProvider = VentaApiProvider();


  Future<bool> registrarVenta(VentaModel ventamodel, String token) async {
    return await _ventaApiProvider.registrarVenta(token, ventamodel);
  }

  //Devuelve el listado de usuarios 
  Future<List<VentaModel>> historial(String token,String filtro, String numeroVenta, String fechaInicio, String fechaFin) async {
    return await _ventaApiProvider.historial(token, filtro,numeroVenta, fechaInicio, fechaFin);
  }


  Future<List<ReporteModel>> reporte(String token,String fechaInicio, String fechaFin) async {
    return await _ventaApiProvider.reporte(token, fechaInicio, fechaFin );
  }

}
