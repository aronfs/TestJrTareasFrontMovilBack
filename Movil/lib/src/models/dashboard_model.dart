import 'package:sistema_ventas_app_v1/src/models/venta_ultima_semana_model.dart';

class DashBoardModel {
  int? totalVentas;
  String? totalIngresos;
  int? totalProductos;
  List<VentaUltimaSemana>? ventaUltimaSemana;

  DashBoardModel(
      {this.totalVentas,
      this.totalIngresos,
      this.totalProductos,
      this.ventaUltimaSemana});

  DashBoardModel.fromJson(Map<String, dynamic> json) {
    totalVentas = json['totalVentas'];
    totalIngresos = json['totalIngresos'];
    totalProductos = json['totalProductos'];
    if (json['ventaUltimaSemana'] != null) {
      ventaUltimaSemana = <VentaUltimaSemana>[];
      json['ventaUltimaSemana'].forEach((v) {
        ventaUltimaSemana!.add(VentaUltimaSemana.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['totalVentas'] = totalVentas;
    data['totalIngresos'] = totalIngresos;
    data['totalProductos'] = totalProductos;
    if (ventaUltimaSemana != null) {
      data['ventaUltimaSemana'] =
          ventaUltimaSemana!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
