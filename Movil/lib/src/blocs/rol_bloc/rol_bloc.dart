import 'package:rxdart/rxdart.dart';
import 'package:sistema_ventas_app_v1/src/models/rol_model.dart';
import 'package:sistema_ventas_app_v1/src/resources/rol_repository.dart';

class RolBloc {
  final _rolRepository = RolRepository();
  final _isLoadingController = BehaviorSubject<bool>();
  Stream<bool> get isLoading => _isLoadingController.stream;

  //Controlamos los datos del rol 
  final _rolController = BehaviorSubject<List<RolModel>>();
  Stream<List<RolModel>> get rol => _rolController.stream;
// Controlador para el rol seleccionado
  final _selectedRoleController = BehaviorSubject<int?>();
  Stream<int?> get selectedRoleStream => _selectedRoleController.stream;

   //Obtener todos los roles
  Future<void> cargarRoles(String token) async {
    try
    {
  _isLoadingController.sink.add(true); //Se inicia la carga
    //Obtenemos la lista de roles
    final roles = await _rolRepository.fetchRol(token);
     //Guardamos la lista de roles
     _rolController.sink.add(roles);
    } catch (er) {
      _rolController.sink.addError("Error al cargar el metodo: $er");
    } finally {
      _isLoadingController.sink.add(false); // Finaliza la carga
    }
  }

  // Seleccionar un rol
  void selectRole(int? roleId) {
    _selectedRoleController.sink.add(roleId);
  }

  // Obtener el rol seleccionado
  int? get selectedRole => _selectedRoleController.valueOrNull;

  void dispose() {
    _isLoadingController.close();
    _rolController.close();
    _selectedRoleController.close();
  }
}



//Instancia global
final rolBloc = RolBloc();
