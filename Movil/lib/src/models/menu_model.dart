class MenuModel {
  final int idMenu;
  final String nombre;
  final String icono;
  final String url;


  MenuModel({
    required this.idMenu,
    required this.nombre,
    required this.icono,
    required this.url

  });

factory MenuModel.fromJson(Map<String, dynamic> json) {
  return MenuModel(
    idMenu: json["idMenu"] ?? 0, 
    nombre: json["nombre"] ?? "No Disponible", 
    icono:  json["icono"], 
    url: json["url"]);
}


//Convertir JSon
Map<String, dynamic> toJson(){
  return {
    "idMenu": idMenu,
    "nombre": nombre,
    "icono": icono,
    "url": url
  };
}




















   
}