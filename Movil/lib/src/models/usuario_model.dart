class UsuarioModel {
  final int? idUsuario;
  final String nombreCompleto;
  final String correo;
  final int idRol;
  final String clave;
  final int esActivo;
  final String? foto;

  UsuarioModel({
     this.idUsuario,
    required this.nombreCompleto,
    required this.correo,
    required this.idRol,
    required this.clave,
    required this.esActivo,
    this.foto,
  });

  
  // Crear un UsuarioModel desde un JSON
  factory UsuarioModel.fromJson(Map<String, dynamic> json) {
    return UsuarioModel(
      idUsuario: json["idUsuario"] ?? 0,
      nombreCompleto: json["nombreCompleto"] ?? "Desconocido",
      correo: json["correo"] ?? "sin-correo@example.com",
      idRol: json["idRol"] ?? 0,
      clave: json["clave"] ?? "",
      esActivo: json["esActivo"] ?? 0,
      foto: json["foto"],
    );
  }

  // Convertir un UsuarioModel a un JSON
  Map<String, dynamic> toJson() {
    return {
      "idUsuario": idUsuario,
      "nombreCompleto": nombreCompleto,
      "correo": correo,
      "idRol": idRol,
      "clave": clave,
      "esActivo": esActivo,
      "foto": foto,
    };
  }
}
