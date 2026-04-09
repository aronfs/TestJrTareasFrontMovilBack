import 'package:rxdart/rxdart.dart';
import 'package:sistema_ventas_app_v1/src/models/usuario_model.dart';
import 'package:sistema_ventas_app_v1/src/resources/usuario_repository.dart';

class UsuarioBloc {
  final _usuarioRepository = UsuarioRepository();
  

  // Controla el estado de carga
  final _isLoadingController = BehaviorSubject<bool>.seeded(false);
  Stream<bool> get isLoading => _isLoadingController.stream;

  // Controla los datos del usuario
  final _usuarioController = BehaviorSubject<UsuarioModel?>();
  Stream<UsuarioModel?> get usuario => _usuarioController.stream;

  // Controla el estado de guardado (true si se crea exitosamente)
  final _usuarioSaveController = BehaviorSubject<bool>.seeded(false);
  Stream<bool> get userSave => _usuarioSaveController.stream;

  // Controla la lista de usuarios
  final _usuarioController1 = BehaviorSubject<List<UsuarioModel>>.seeded([]);
  Stream<List<UsuarioModel>> get usuariosStream => _usuarioController1.stream;

  // Controlar el update de usuarios
  final _usuarioUpdateController = BehaviorSubject<bool?>.seeded(null);
  Stream<bool?> get usuariosUpdateStream => _usuarioUpdateController.stream;

  // Controlar el delete de usuarios
  final _usuarioEliminarController = BehaviorSubject<bool>.seeded(false);
  Stream<bool> get usuariosEliminarStream => _usuarioEliminarController.stream;

  // Obtener el usuario a partir del token decodificado
  Future<bool> fetchUsuario(String token, String correo) async {
    _setLoadingState(true);
    try {
      final usuarios = await _usuarioRepository.fetchUsuario(token);
      final usuarioEncontrado = usuarios.firstWhere(
        (u) => u.correo == correo,
        orElse: () => throw Exception('Usuario no encontrado con correo: $correo'),
      );
      _usuarioController.add(usuarioEncontrado);
      return true; // Return true if successful
    } catch (e) {
      _usuarioController.addError('Error al obtener el usuario: $e');
      return false; // Return false if an error occurs
    } finally {
      _setLoadingState(false);
    }
  }

  // Obtener la lista de usuarios
  Future<bool> cargarUsuarios(String token) async {
   _setLoadingState(true);
try {
  final usuarios = await _usuarioRepository.fetchUsuario(token);
  _usuarioController1.add(usuarios);
  return true;
} catch (e) {
//  _usuarioController1.addError('Error al cargar usuarios: $e');
  return false;
}
_setLoadingState(false);
  }

  // Crear un nuevo usuario
  Future<bool> crearUsuario(String token, UsuarioModel usuario) async {
    _setLoadingState(true);
    try {
      final usuarioCreado = await _usuarioRepository.saveUsuario(usuario, token);
      if (usuarioCreado) {
        _usuarioSaveController.add(true); // Éxito
        return true;
      } else {
        _usuarioSaveController.add(false); // Error
        return false;
      }
    } catch (e) {
      _usuarioSaveController.add(false);
      print('❌ Error en crearUsuario: $e');
      return false;
    } finally {
      _setLoadingState(false);
    }
  }

  // Actualizar usuario
  Future<bool> actualizarUsuario(String token, UsuarioModel usuario) async {
    try {
      final actualizado = await _usuarioRepository.updateUsuario(token, usuario);
      _usuarioUpdateController.add(actualizado);
      return actualizado;
    } catch (e) {
      _usuarioUpdateController.add(false);
      print('❌ Error en actualizarUsuario: $e');
      return false;
    }
  }

  // Eliminar usuario
  Future<bool> eliminarUsuario(String token, int idUsuario) async {
    try {
      final eliminar = await _usuarioRepository.deleteUsuario(idUsuario, token);
      _usuarioEliminarController.add(eliminar);
      return eliminar;
    } catch (e) {
      _usuarioEliminarController.add(false);
      print('❌ Error en Eliminar Usuario: $e');
    }
    return false;
  }

  // Control de estado de carga
  void _setLoadingState(bool isLoading) {
    if (!_isLoadingController.isClosed) {
      _isLoadingController.add(isLoading);
    }
  }

  // Limpiar los streams
  void dispose() {
    _isLoadingController.close();
    _usuarioController.close();
    _usuarioController1.close();
    _usuarioSaveController.close();
    _usuarioUpdateController.close();
    _usuarioEliminarController.close();
  }
}

// Instancia global del UsuarioBloc
final usuarioBloc = UsuarioBloc();
