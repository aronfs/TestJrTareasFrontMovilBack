class ReporteModel {
  String? numeroDocumento;
  String? tipoPago;
  String? totalVenta;
  String? fechaRegistro;
  String? producto;
  int? cantidad;
  String? precio;
  String? total;

  ReporteModel(
      {this.numeroDocumento,
      this.tipoPago,
      this.totalVenta,
      this.fechaRegistro,
      this.producto,
      this.cantidad,
      this.precio,
      this.total});

  ReporteModel.fromJson(Map<String, dynamic> json) {
    numeroDocumento = json['numeroDocumento'];
    tipoPago = json['tipoPago'];
    totalVenta = json['totalVenta'];
    fechaRegistro = json['fechaRegistro'];
    producto = json['producto'];
    cantidad = json['cantidad'];
    precio = json['precio'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['numeroDocumento'] = numeroDocumento;
    data['tipoPago'] = tipoPago;
    data['totalVenta'] = totalVenta;
    data['fechaRegistro'] = fechaRegistro;
    data['producto'] = producto;
    data['cantidad'] = cantidad;
    data['precio'] = precio;
    data['total'] = total;
    return data;
  }
}