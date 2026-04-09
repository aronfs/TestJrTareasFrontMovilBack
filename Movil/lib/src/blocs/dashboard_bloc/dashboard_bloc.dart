import 'package:rxdart/rxdart.dart';
import 'package:sistema_ventas_app_v1/src/models/dashboard_model.dart';
import 'package:sistema_ventas_app_v1/src/resources/dashboard_repository.dart';

class DashboardBloc {
  final _dashboardRepository = DashboardRepository();
  

  // Controla el estado de carga
  final _isLoadingController = BehaviorSubject<bool>();
  Stream<bool> get isLoading => _isLoadingController.stream;

  // Controla los menús dinámicos
  final _dashboardController = BehaviorSubject<List<DashBoardModel>>();
  Stream<List<DashBoardModel>> get dashboard => _dashboardController.stream;

  // Método para cargar los menús dinámicos
  Future<List<DashBoardModel>> fetchDashboard(String token) async {
    try {

      _isLoadingController.sink.add(true); // Inicia la carga

      // Llamada al API para obtener los menús
      final menus = await _dashboardRepository.fetchDashboard(token);
      print('[fetchMenus] Menús obtenidos: ${menus.map((m) => m.toJson()).toList()}');

      _dashboardController.sink.add(menus); // Emitir los menús obtenidos
      return menus; // Ensure a value is returned
    } catch (e, s) {
      print('[fetchMenus] Error al cargar menús: $e\n$s');
      _dashboardController.sink.addError('Error al cargar menús: $e');
      throw Exception('Error al cargar menús: $e'); // Throw an exception
    } finally {
      _isLoadingController.sink.add(false); // Finaliza la carga
    }
  }

  // Limpiar los streams
  void dispose() {
    _isLoadingController.close();
    _dashboardController.close();
  }
}

// Instancia global del MenuBloc
final dashboardBloc = DashboardBloc();