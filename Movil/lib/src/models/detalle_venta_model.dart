class DetalleVenta {
  int? idProducto;
  String? descripcionProducto;
  int? cantidad;
  String? precioTexto;
  String? totalTexto;

  DetalleVenta(
      {this.idProducto,
      this.descripcionProducto,
      this.cantidad,
      this.precioTexto,
      this.totalTexto});

  DetalleVenta.fromJson(Map<String, dynamic> json) {
    idProducto = json['idProducto'];
    descripcionProducto = json['descripcionProducto'];
    cantidad = json['cantidad'];
    precioTexto = json['precioTexto'];
    totalTexto = json['totalTexto'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['idProducto'] = idProducto;
    data['descripcionProducto'] = descripcionProducto;
    data['cantidad'] = cantidad;
    data['precioTexto'] = precioTexto;
    data['totalTexto'] = totalTexto;
    return data;
  }
}