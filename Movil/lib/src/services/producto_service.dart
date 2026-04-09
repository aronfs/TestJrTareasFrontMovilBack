import 'package:flutter/material.dart';
import 'package:sistema_ventas_app_v1/src/blocs/categoria_bloc/categoria_bloc.dart';
import 'package:sistema_ventas_app_v1/src/blocs/producto_bloc/producto_bloc.dart';
import 'package:sistema_ventas_app_v1/src/models/categoria_model.dart';
import 'package:sistema_ventas_app_v1/src/models/producto_model.dart';
import 'package:sistema_ventas_app_v1/src/utility/session_manager.dart';

class ProductoService {
  final ProductoBloc _productoBloc = productoBloc;
  final CategoriaBloc _categoriaBloc = categoriaBloc;
  final SessionManager _sessionManager = SessionManager(); // Usa la instancia global
List<ProductoModel> _productos = [];
  // ✅ Mostrar un mensaje en pantalla
  void _mostrarMensaje(BuildContext context, String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mensaje)));
  }

  // ✅ Cargar productos con sus nombres de categoría
  Future<List<ProductoModel>> cargarProductosConCategorias(BuildContext context) async {
    await _sessionManager.init();
    try {
      final token = _sessionManager.token;
      if (token == null || token.isEmpty) {
        print('⚠️ No se encontró el token.');
        _mostrarMensaje(context, 'Token no encontrado');
        return [];
      }

      // ✅ Cargar productos y categorías desde los BLoCs
      final productos = await _productoBloc.cargarProductos(token);
      final categorias = await _categoriaBloc.cargarCategorias(token);
      _productos = await _productoBloc.cargarProductos(token);
      if (productos.isEmpty || categorias.isEmpty) {
        print('❌ Error: No se encontraron productos o categorías.');
        _mostrarMensaje(context, 'No hay productos o categorías disponibles.');
        return [];
      }

      // ✅ Crear un mapa para acceder a las categorías rápidamente
      final Map<int, CategoriaModel> categoriaMap = {
        for (var categoria in categorias) categoria.idCategoria: categoria
      };

      // ✅ Asignar el nombre de la categoría a cada producto
      final productosConCategoria = productos.map((producto) {
        final nombreCategoria = categoriaMap[producto.idCategoria]?.nombre ?? 'Sin categoría';
        return producto.copyWith(descripcionCategoria: nombreCategoria);
      }).toList();

      return productosConCategoria;
    } catch (e) {
      print('❌ Error al cargar productos con categorías: $e');
      _mostrarMensaje(context, 'Error al cargar productos con categorías.');
      return [];
    }
  }



 Future<ProductoModel> getProductoById(int productoId) async {
  // Inicializar sesión y obtener el token
  await _sessionManager.init();
  final token = _sessionManager.token;

  if (token == null || token.isEmpty) {
    print('⚠️ No se encontró el token.');
    return ProductoModel(idProducto: -1, nombre: 'Token no válido');
  }

  // Cargar productos y categorías
  _productos = await _productoBloc.cargarProductos(token);
  final categorias = await _categoriaBloc.cargarCategorias(token);

  // Buscar el producto por ID
  final producto = _productos.firstWhere(
    (p) => p.idProducto == productoId,
    orElse: () => ProductoModel(idProducto: productoId, nombre: 'Producto desconocido'),
  );

  // Si el producto tiene una categoría asignada, buscar su detalle
  if (producto.idCategoria != null) {
    final categoriaEncontrada = categorias.firstWhere(
      (c) => c.idCategoria == producto.idCategoria,
      orElse: () => CategoriaModel(idCategoria: producto.idCategoria ?? -1, nombre: 'Categoría desconocida'),
    );

    // Asignar la categoría al producto
    producto.descripcionCategoria = categoriaEncontrada.nombre;
  }

  return producto;
}


//Crear Producto
Future<void> guardarProducto({
    required BuildContext context,
    required GlobalKey<FormState> formKey,
    required String nombre,
    required int stock,
    required String precio,
    required int? selectedCategoria,//Categoria
    required int? estadoSeleccionado,
    required String? fotoBase64,
  }) async {
    await _sessionManager.init();
    if (!formKey.currentState!.validate()) return;

    if (selectedCategoria == null) {
      _mostrarMensaje(context, 'Seleccione una Categoria');
      return;
    }

    if (estadoSeleccionado == null) {
      _mostrarMensaje(context, 'Seleccione un estado');
      return;
    }

    final token = _sessionManager.token;
    if (token == null || token.isEmpty) {
      print('⚠️ No se encontró el token.');
      return;
    }

    final nuevoProducto = ProductoModel(
      idProducto: 0,
      nombre: nombre.trim(),
      stock: stock,
      precio: precio,
      idCategoria: selectedCategoria,
      esActivo: estadoSeleccionado,
      foto: fotoBase64,
    );

    try {
      final resultado = await _productoBloc.crearProducto(token, nuevoProducto);
      if (resultado) {
        _mostrarMensaje(context, 'Producto creado exitosamente');
        Navigator.pop(context);
      } else {
        _mostrarMensaje(context, 'Error al crear el producto');
      }
    } catch (e) {
      print('❌ Error al crear producto: $e');
      _mostrarMensaje(context, 'Error al crear el producto');
    }
  }
Future<void> actualizarProducto({
    required BuildContext context,
    required GlobalKey<FormState> formKey,
    required String nombre,
    required int stock,
    required String precio,
    required int? selectedCategoria,//Categoria
    required int? estadoSeleccionado,
    required String? fotoBase64,
    required int idProducto,
  }) async {
    await _sessionManager.init();
    if (!formKey.currentState!.validate()) return;

    if (selectedCategoria == null) {
      _mostrarMensaje(context, 'Seleccione una Categoria');
      return;
    }

    if (estadoSeleccionado == null) {
      _mostrarMensaje(context, 'Seleccione un estado');
      return;
    }

    final token = _sessionManager.token;
    if (token == null || token.isEmpty) {
      print('⚠️ No se encontró el token.');
      return;
    }

   final actualizadoProducto = ProductoModel(
      idProducto: idProducto,
      nombre: nombre.trim(),
      stock: stock,
      precio: precio,
      idCategoria: selectedCategoria,
      esActivo: estadoSeleccionado,
      foto: fotoBase64,
    );
    try {
      final resultado = await _productoBloc.actualizarProducto(token, actualizadoProducto);
      if (resultado) {
        _mostrarMensaje(context, 'Usuario actualizado exitosamente');
        Navigator.pop(context);
      } else {
        _mostrarMensaje(context, 'Error al actualizar el usuario');
      }
    } catch (e) {
      print('❌ Error al actualizar usuario: $e');
      _mostrarMensaje(context, '❌ Error al actualizar el usuario');
    }
  }


Future<void> eliminarProducto({
    required BuildContext context,
    required int idProducto
  }) async {
    await _sessionManager.init();
    final token = _sessionManager.token;

    if (token == null || token.isEmpty) {
      print('⚠️ No se encontró el token.');
      return;
    }

    try {
      final eliminado = await _productoBloc.eliminarProducto(token, idProducto);
      if (eliminado) {
        _mostrarMensaje(context, '✅ Producto eliminado exitosamente');
        print(eliminado);
      } else {
        _mostrarMensaje(context, '❌ Error al eliminar el Producto');
         print(eliminado);
      }
    } catch (e) {
      print('❌ Error al eliminar usuario: $e');
      _mostrarMensaje(context, '❌ Ocurrió un error al eliminar el usuario');
    }
  }




}
