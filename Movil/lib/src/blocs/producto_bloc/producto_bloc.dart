import 'package:rxdart/rxdart.dart';
import 'package:sistema_ventas_app_v1/src/blocs/categoria_bloc/categoria_bloc.dart';
import 'package:sistema_ventas_app_v1/src/models/producto_model.dart';
import 'package:sistema_ventas_app_v1/src/resources/producto_repository.dart';

class ProductoBloc {
  final _productoRepository = ProductoRepository();

  // Controla el estado de carga
  final _isLoadingController = BehaviorSubject<bool>.seeded(false);
  Stream<bool> get isLoading => _isLoadingController.stream;

  // Controla la lista de productos
  final _productosController = BehaviorSubject<List<ProductoModel>>.seeded([]);
  Stream<List<ProductoModel>> get productosStream => _productosController.stream;

  // Controla el estado de guardado (true si se guarda exitosamente)
  final _productoSaveController = BehaviorSubject<bool>.seeded(false);
  Stream<bool> get productoSaveStream => _productoSaveController.stream;

  // Controla el estado de actualización
  final _productoUpdateController = BehaviorSubject<bool>.seeded(false);
  Stream<bool> get productoUpdateStream => _productoUpdateController.stream;

  // Controla el estado de eliminación
  final _productoDeleteController = BehaviorSubject<bool>.seeded(false);
  Stream<bool> get productoDeleteStream => _productoDeleteController.stream;

    final _selectedProductoController = BehaviorSubject<int?>();
  Stream<int?> get selectedProducto => _selectedProductoController.stream;


  // Cargar productos y asignar categoría asociada
Future<List<ProductoModel>> cargarProductos(String token) async {
  _setLoadingState(true);
  try {
    // Obtener productos
    final productos = await _productoRepository.fetchProductos(token);

    // Cargar categorías si no están disponibles
    final categorias = await categoriaBloc.categorias.first;
    if ((categorias ?? []).isEmpty) {
      await categoriaBloc.cargarCategorias(token);
    }

    // Asignar el nombre de la categoría al producto
    final productosConCategoria = productos.map((producto) {
      final categoria = producto.idCategoria != null 
          ? categoriaBloc.buscarCategoriaPorId(producto.idCategoria!) 
          : null;
      return producto.copyWith(descripcionCategoria: categoria?.nombre ?? 'Desconocida');
    }).toList();

    _productosController.add(productosConCategoria);
    return productosConCategoria;
  } catch (e) {
    _productosController.addError('❌ Error al cargar productos: $e');
    return [];
  } finally {
    _setLoadingState(false);
  }
}

  // Crear un nuevo producto
  Future<bool> crearProducto(String token, ProductoModel producto) async {
    _setLoadingState(true);
    try {
      final creado = await _productoRepository.saveProductos(producto, token);
      _productoSaveController.add(creado);
      if (creado) {
        await cargarProductos(token); // Recargar la lista
      }
      return creado;
    } catch (e) {
      _productoSaveController.add(false);
      print('❌ Error al crear producto: $e');
      return false;
    } finally {
      _setLoadingState(false);
    }
  }

  // Actualizar un producto
  Future<bool> actualizarProducto(String token, ProductoModel producto) async {
    _setLoadingState(true);
    try {
      final actualizado = await _productoRepository.updateProductos(token, producto);
      _productoUpdateController.add(actualizado);
      if (actualizado) {
        await cargarProductos(token); // Recargar la lista
      }
      return actualizado;
    } catch (e) {
      _productoUpdateController.add(false);
      print('❌ Error al actualizar producto: $e');
      return false;
    } finally {
      _setLoadingState(false);
    }
  }

  // Eliminar un producto
  Future<bool> eliminarProducto(String token, int idProducto) async {
    _setLoadingState(true);
    try {
      final eliminado = await _productoRepository.deleteProductos(idProducto, token);
      _productoDeleteController.add(eliminado);
      if (eliminado) {
        await cargarProductos(token); // Recargar la lista
      }
      return eliminado;
    } catch (e) {
      _productoDeleteController.add(false);
      print('❌ Error al eliminar producto: $e');
      return false;
    } finally {
      _setLoadingState(false);
    }
  }
    // Seleccionar una categoría
  void seleccionarProducto(int? idProducto) {
    if (!_selectedProductoController.isClosed) {
      _selectedProductoController.add(idProducto);
    }
  }

  // Establecer el estado de carga
  void _setLoadingState(bool isLoading) {
    if (!_isLoadingController.isClosed) {
      _isLoadingController.add(isLoading);
    }
  }

  // Liberar los recursos
  void dispose() {
    _isLoadingController.close();
    _productosController.close();
    _productoSaveController.close();
    _productoUpdateController.close();
    _productoDeleteController.close();
  }
}

// Instancia global del ProductoBloc
final productoBloc = ProductoBloc();
