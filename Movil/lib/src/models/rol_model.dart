class RolModel {
  int? idRol;
  String? nombre;

  RolModel({this.idRol, this.nombre});

  RolModel.fromJson(Map<String, dynamic> json) {
    idRol = json['idRol'] ?? 0;
    nombre = json['nombre'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['idRol'] = idRol;
    data['nombre'] = nombre;
    return data;
  }
}