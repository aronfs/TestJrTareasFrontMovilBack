import 'package:rxdart/rxdart.dart';
import 'package:sistema_ventas_app_v1/src/models/menu_model.dart';
import 'package:sistema_ventas_app_v1/src/models/usuario_model.dart';
import 'package:sistema_ventas_app_v1/src/resources/menu_repository.dart';
import 'package:sistema_ventas_app_v1/src/resources/usuario_repository.dart';

class MenuBloc {
  final _menuRepository = MenuRepository();
  final _usuarioRepository = UsuarioRepository();

  // Controla el estado de carga
  final _isLoadingController = BehaviorSubject<bool>();
  Stream<bool> get isLoading => _isLoadingController.stream;

  // Controla los menús dinámicos
  final _menusController = BehaviorSubject<List<MenuModel>>();
  Stream<List<MenuModel>> get menus => _menusController.stream;

  // Controla el usuario encontrado
  final _usuarioController = BehaviorSubject<UsuarioModel?>();
  Stream<UsuarioModel?> get usuario => _usuarioController.stream;

  

  // Obtener el usuario a partir del token decodificado
  Future<void> fetchUsuario(String token, String correo) async {

    try {
  

      _isLoadingController.sink.add(true); // Inicia la carga

      // Obtener la lista de usuarios desde el API
      final usuarios = await _usuarioRepository.fetchUsuario(token);
      print('[fetchUsuario] Usuarios obtenidos: ${usuarios.map((u) => u.toJson()).toList()}');

      // Buscar el usuario cuyo correo coincide
      final usuarioEncontrado = usuarios.firstWhere(
        (u) => u.correo == correo,
        orElse: () {
          print('[fetchUsuario] Usuario no encontrado con correo: $correo');
          throw Exception('Usuario no encontrado');
        },
      );

      print('[fetchUsuario] Usuario encontrado: ${usuarioEncontrado.toJson()}');
      _usuarioController.sink.add(usuarioEncontrado);

      // Cargar los menús si encontramos el usuario
      await fetchMenus(token, usuarioEncontrado.idUsuario!);
    } catch (e, s) {
      print('[fetchUsuario] Error: $e\n$s');
      _usuarioController.sink.addError('Error al obtener el usuario: $e');
    } finally {
      _isLoadingController.sink.add(false); // Finaliza la carga
    }
  }

  // Método para cargar los menús dinámicos
  Future<void> fetchMenus(String token, int idUsuario) async {
     print('🔍 Iniciando fetchUsuario...');
print('🔍 Iniciando fetchMenus...');

    try {
      print('[fetchMenus] Iniciando con idUsuario: $idUsuario');
      _isLoadingController.sink.add(true); // Inicia la carga

      // Llamada al API para obtener los menús
      final menus = await _menuRepository.fetchMenus(token, idUsuario);
      print('[fetchMenus] Menús obtenidos: ${menus.map((m) => m.toJson()).toList()}');

      _menusController.sink.add(menus); // Emitir los menús obtenidos
    } catch (e, s) {
      print('[fetchMenus] Error al cargar menús: $e\n$s');
      _menusController.sink.addError('Error al cargar menús: $e');
    } finally {
      _isLoadingController.sink.add(false); // Finaliza la carga
    }
  }

  // Limpiar los streams
  void dispose() {
    _isLoadingController.close();
    _menusController.close();
    _usuarioController.close();
  }
}

// Instancia global del MenuBloc
final menuBloc = MenuBloc();