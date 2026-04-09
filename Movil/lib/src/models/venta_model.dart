import 'package:sistema_ventas_app_v1/src/models/detalle_venta_model.dart';

class VentaModel {
  int? idVenta;
  String? numeroDocumento;

  String? tipoPago;
  String? totalTexto;
  String? fechaRegistro;
  List<DetalleVenta>? detalleVenta;

  VentaModel(
      {this.idVenta,
      this.numeroDocumento,
      this.tipoPago,

      this.totalTexto,
      this.fechaRegistro,
      this.detalleVenta});

  VentaModel.fromJson(Map<String, dynamic> json) {
    idVenta = json['idVenta'];
    numeroDocumento = json['numeroDocumento'];

    tipoPago = json['tipoPago'];
    totalTexto = json['totalTexto'];
    fechaRegistro = json['fechaRegistro'];
    if (json['detalleVenta'] != null) {
      detalleVenta = <DetalleVenta>[];
      json['detalleVenta'].forEach((v) {
        detalleVenta!.add(DetalleVenta.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['idVenta'] = idVenta;
    data['numeroDocumento'] = numeroDocumento;
    data['tipoPago'] = tipoPago;
    data['totalTexto'] = totalTexto;
    data['fechaRegistro'] = fechaRegistro;
    if (detalleVenta != null) {
      data['detalleVenta'] = detalleVenta!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}