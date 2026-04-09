

import 'package:flutter/widgets.dart';
import 'package:sistema_ventas_app_v1/src/blocs/categoria_bloc/categoria_bloc.dart';
import 'package:sistema_ventas_app_v1/src/utility/session_manager.dart';

class CategoriaService {
  final SessionManager sessionManager = SessionManager();
  final CategoriaBloc _categoriaBloc = categoriaBloc;

  //Cargamos las categorias desde el bloc para obtener todo el listado en el Back end 
  Future<void> cargarCategoriasProducto(BuildContext context)async {
    await sessionManager.init();
    try{
      final token = sessionManager.token;
      if(token == null || token.isEmpty){
        print("No se encontro el token");
        return;

      }
      
      await _categoriaBloc.cargarCategorias(token);
      _categoriaBloc.categorias.first.then((categorias) {
        if (categorias.isEmpty){
          print("Categorias Cargadas: ${categorias.length}");
        }else {
          print("No se encontraron categorias");
        }
      }).catchError((error){
        print("Error al obtener las categorias: $error");
      });
      


      }catch (e) {
      print('❌ Error al cargar el rol BLoC: $e');
    }
  }
}