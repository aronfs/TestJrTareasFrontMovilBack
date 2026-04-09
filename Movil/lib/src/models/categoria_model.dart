class CategoriaModel {
  final int idCategoria;
  final String nombre;

  CategoriaModel({
    required this.idCategoria,
    required this.nombre,
  });

  // ✅ Factory para crear una instancia desde un JSON
  factory CategoriaModel.fromJson(Map<String, dynamic> json) {
    return CategoriaModel(
      idCategoria: json["idCategoria"] ?? 0,
      nombre: json["nombre"] ?? "Sin Categoría",
    );
  }

  // ✅ Método para convertir el objeto a JSON
  Map<String, dynamic> toJson() {
    return {
      "idCategoria": idCategoria,
      "nombre": nombre,
    };
  }

  // ✅ Método copyWith para crear una copia con modificaciones
  CategoriaModel copyWith({
    int? idCategoria,
    String? nombre,
  }) {
    return CategoriaModel(
      idCategoria: idCategoria ?? this.idCategoria,
      nombre: nombre ?? this.nombre,
    );
  }

  @override
  String toString() {
    return 'CategoriaModel(idCategoria: $idCategoria, nombre: $nombre)';
  }
}
