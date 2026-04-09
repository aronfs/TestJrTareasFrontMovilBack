import 'package:rxdart/rxdart.dart';
import 'package:sistema_ventas_app_v1/src/models/categoria_model.dart';
import 'package:sistema_ventas_app_v1/src/resources/categoria_repository.dart';

class CategoriaBloc {
  final _categoriaRepository = CategoriaRepository();

  // Controla el estado de carga
  final _isLoadingController = BehaviorSubject<bool>.seeded(false);
  Stream<bool> get isLoading => _isLoadingController.stream;

  // Controla la lista de categorías
  final _categoriaController = BehaviorSubject<List<CategoriaModel>>.seeded([]);
  Stream<List<CategoriaModel>> get categorias => _categoriaController.stream;

  // Controla la categoría seleccionada
  final _selectedCategoriaController = BehaviorSubject<int?>();
  Stream<int?> get selectedCategoriaStream => _selectedCategoriaController.stream;

  // Cargar todas las categorías y emitirlas en el stream
  Future<List<CategoriaModel>> cargarCategorias(String token) async {
    _setLoadingState(true);
    try {
      final categorias = await _categoriaRepository.fetchCategorias(token);
      if (!_categoriaController.isClosed) {
        _categoriaController.add(categorias);
      }
      return categorias;
    } catch (er) {
      _categoriaController.addError("❌ Error al cargar las categorías: $er");
      throw Exception("Error al cargar las categorías: $er");
    } finally {
      _setLoadingState(false);
    }
  }

  // Buscar una categoría por ID
  CategoriaModel? buscarCategoriaPorId(int idCategoria) {
    final categorias = _categoriaController.valueOrNull ?? [];
    try {
      return categorias.firstWhere((c) => c.idCategoria == idCategoria);
    } catch (_) {
      return null; // Si no encuentra la categoría, devuelve null
    }
  }

  // Seleccionar una categoría
  void seleccionarCategoria(int? categoriaId) {
    if (!_selectedCategoriaController.isClosed) {
      _selectedCategoriaController.add(categoriaId);
    }
  }

  // Obtener la categoría seleccionada
  int? get categoriaSeleccionada => _selectedCategoriaController.valueOrNull;

  // Control de estado de carga
  void _setLoadingState(bool isLoading) {
    if (!_isLoadingController.isClosed) {
      _isLoadingController.add(isLoading);
    }
  }

  // Limpiar recursos
  void dispose() {
    _isLoadingController.close();
    _categoriaController.close();
    _selectedCategoriaController.close();
  }
}

// Instancia global
final categoriaBloc = CategoriaBloc();
