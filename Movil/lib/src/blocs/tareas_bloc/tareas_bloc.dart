



import 'package:rxdart/rxdart.dart';
import 'package:sistema_ventas_app_v1/src/models/tareas_model.dart';
import 'package:sistema_ventas_app_v1/src/resources/tareas_repository.dart';
import 'package:sistema_ventas_app_v1/src/resources/usuario_repository.dart';

class TareasBloc { 
  final _tareasRepository = TareasRepository();
  final _usuarioRepository = UsuarioRepository();
 
  final _isLoadingController = BehaviorSubject<bool>.seeded(false);
  Stream<bool> get isLoading => _isLoadingController.stream;

  final _tareasController = BehaviorSubject<List<Tareas>>.seeded([]);
  Stream<List<Tareas>> get tareasStream => _tareasController.stream;

  final _tareasSaveController = BehaviorSubject<bool>.seeded(false);
  Stream<bool> get tareasSave => _tareasSaveController.stream;

  final _tareasUpdateController = BehaviorSubject<bool>.seeded(false);
  Stream<bool> get  tareasUpdate => _tareasUpdateController.stream;

  final _tareasCompleteController =  BehaviorSubject<bool>.seeded(false);
  Stream<bool> get tareasComplete => _tareasCompleteController.stream;

  final _tareasInactiveController = BehaviorSubject<bool>.seeded(false);
  Stream<bool> get  tareasInactive => _tareasInactiveController.stream;


  Future<List<Tareas>> cargarTareas(String token, String? correo) async {
    _setLoadingState(true);
    try {
   final usuarios = await _usuarioRepository.fetchUsuario(token);
      final usuarioEncontrado = usuarios.firstWhere(
        (u) => u.correo == correo,
        orElse: () => throw Exception('Usuario no encontrado con correo: $correo'),
      );

      final tareasCreado = await _tareasRepository.fetchTareas(token, usuarioEncontrado.idUsuario);
      _tareasController.add(tareasCreado);
       return tareasCreado;
    } catch (e) {
      return [];
    }
  }


    void _setLoadingState(bool isLoading) {
    if (!_isLoadingController.isClosed) {
      _isLoadingController.add(isLoading);
    }
  }

  Future<bool>crearTarea(String token, Tareas tarea) async {
    _setLoadingState(true);
    try {
      final tareaCreada = await _tareasRepository.saveTarea(tarea, token);
      if (tareaCreada) {
        _tareasSaveController.add(true);
        return true;
      }else {
        _tareasSaveController.add(false);
        return false;
      }
    } catch (e) {
      print('❌ Error en crear Tarea: $e');
      return false;
    }
  }

  Future<bool> actualizarTarea(String token, Tareas tarea) async { 
     _setLoadingState(true);
     try {
       final actualizado = await _tareasRepository.updateTarea(tarea, token);
       _tareasUpdateController.add(actualizado);
       return actualizado;
     } catch (e) {
        print('❌ Error en actualizar Tarea: $e');
      return false;
     }
  }

  Future<bool> completarTarea(String token, int? id) async { 
     _setLoadingState(true);
     try {
       final actualizado = await _tareasRepository.completarTarea( token, id);
       _tareasCompleteController.add(actualizado);
       return actualizado;
     } catch (e) {
        print('❌ Error en actualizar Tarea: $e');
      return false;
     }
  }



  Future<bool> inactivarTarea(String token, int? id) async { 
     _setLoadingState(true);
     try {
       final actualizado = await _tareasRepository.inactivarTarea( token, id);
       _tareasInactiveController.add(actualizado);
       return actualizado;
     } catch (e) {
        print('❌ Error en actualizar Tarea: $e');
      return false;
     }
  }

  void dispose(){
    _isLoadingController.close();
    _tareasCompleteController.close();
    _tareasController.close();
    _tareasSaveController.close();
    _tareasUpdateController.close();
  }

}


final tareasBloc = TareasBloc();