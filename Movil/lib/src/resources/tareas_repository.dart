



import 'package:sistema_ventas_app_v1/src/models/tareas_model.dart';
import 'package:sistema_ventas_app_v1/src/resources/tareas_api_provider.dart';

class TareasRepository {
  final TareasApiProvider _tareasApiProvider = TareasApiProvider();

  Future<List<Tareas>> fetchTareas(String token, int? id) async  {
    return await _tareasApiProvider.fetchTareas(token, id);
  }

  Future<bool> saveTarea(Tareas tarea, String token) async { 
    return await _tareasApiProvider.crearTarea(token, tarea);
  }

  Future<bool> updateTarea (Tareas tarea, String token) async { 
    return await _tareasApiProvider.actualizarTarea(token, tarea);
  }

  Future<bool> completarTarea (String token, int? id) async {
    return await _tareasApiProvider.completarTarea(token, id);
  }

  Future<bool> inactivarTarea (String token, int? id) async { 
    return await _tareasApiProvider.inactivarTarea(token, id);
  }

}