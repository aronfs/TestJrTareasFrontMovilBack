import 'dart:async';
import 'package:sistema_ventas_app_v1/src/models/producto_model.dart';
import 'package:sistema_ventas_app_v1/src/resources/producto_api_provider.dart';


class ProductoRepository {
  final ProductoApiProvider _productoApiProvider = ProductoApiProvider();

  //Devuelve el listado de usuarios 
  Future<List<ProductoModel>> fetchProductos(String token) async {
    return await _productoApiProvider.fetchProductos(token);
  }

  Future<bool> saveProductos(ProductoModel usuario, String token) async {
    return await _productoApiProvider.crearProducto(token, usuario);
  }

  Future<bool> updateProductos(String token,ProductoModel usuario,) async {
    return await _productoApiProvider.actualizarProducto(token, usuario);
  }

  Future<bool> deleteProductos(int idUsuario, String token) async {
    return await _productoApiProvider.eliminarProducto(token,idUsuario);
  }
}
