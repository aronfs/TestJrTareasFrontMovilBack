class ProductoModel {
  final int idProducto;
  final String? nombre;
  final int? idCategoria;
   String? descripcionCategoria;
  final int? stock;
  final String? precio;
  final int? esActivo;
  final String? foto;

  ProductoModel({
    required this.idProducto,
    this.nombre,
    this.idCategoria,
    this.descripcionCategoria,
    this.stock,
    this.precio,
    this.esActivo,
    this.foto,
  });

  // ✅ Factory para crear una instancia desde un JSON
  factory ProductoModel.fromJson(Map<String, dynamic> json) {
    return ProductoModel(
      idProducto: json['idProducto'] ?? 0,
      nombre: json['nombre'] ?? "Sin Nombre",
      idCategoria: json['idCategoria'] ?? 0,
      descripcionCategoria: json['descripcionCategoria'] ?? "Cargar Categoría",
      stock: json['stock'] ?? 0,
      precio: json['precio']?.toString() ?? "0.00", // ✅ Asegura tipo String
      esActivo: json['esActivo'] ?? 0,
      foto: json['foto'],
    );
  }

  // ✅ Método para convertir el objeto a JSON
  Map<String, dynamic> toJson() {
    return {
      'idProducto': idProducto,
      'nombre': nombre,
      'idCategoria': idCategoria,
      'descripcionCategoria': descripcionCategoria,
      'stock': stock,
      'precio': precio,
      'esActivo': esActivo,
      'foto': foto,
    };
  }

  // ✅ Método copyWith para crear una copia con modificaciones
  ProductoModel copyWith({
    int? idProducto,
    String? nombre,
    int? idCategoria,
    String? descripcionCategoria,
    int? stock,
    String? precio,
    int? esActivo,
    String? foto,
  }) {
    return ProductoModel(
      idProducto: idProducto ?? this.idProducto,
      nombre: nombre ?? this.nombre,
      idCategoria: idCategoria ?? this.idCategoria,
      descripcionCategoria: descripcionCategoria ?? this.descripcionCategoria,
      stock: stock ?? this.stock,
      precio: precio ?? this.precio,
      esActivo: esActivo ?? this.esActivo,
      foto: foto ?? this.foto,
    );
  }

  @override
  String toString() {
    return 'ProductoModel(idProducto: $idProducto, nombre: $nombre, idCategoria: $idCategoria, descripcionCategoria: $descripcionCategoria, stock: $stock, precio: $precio, esActivo: $esActivo, foto: $foto)';
  }
}
