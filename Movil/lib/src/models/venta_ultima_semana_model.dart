class VentaUltimaSemana {
  String? fecha;
  int? total;

  VentaUltimaSemana({this.fecha, this.total});

  VentaUltimaSemana.fromJson(Map<String, dynamic> json) {
    fecha = json['fecha'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['fecha'] = fecha;
    data['total'] = total;
    return data;
  }
}