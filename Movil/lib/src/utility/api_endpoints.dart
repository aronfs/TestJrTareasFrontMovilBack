import 'package:sistema_ventas_app_v1/src/utility/env.dart';

class ApiEndpoints {

  // URL base de la API
  static final String baseUrl = Env.baseUrl;

  // Endpoints de autenticación
  static final String login = '$baseUrl/Auth/login';

  // Endpoints de usuario
  static final String getUsuario = '$baseUrl/Usuario/Lista';
  static final String getFotoUsuario = '$baseUrl/Usuario/ObtenerFotoPorCorreo';
  static final String saveUsuario = '$baseUrl/Usuario/Guardar';
  static final String updateUsuario = '$baseUrl/Usuario/Editar';
  static final String deleteUsuario = '$baseUrl/Usuario/Eliminar';
  // Endpoint de Menu
  static final String getListaMenu = '$baseUrl/Menu/Lista';
  //Endpoint de Rolesç
  static final String getRoles = '$baseUrl/Rol/Lista';
  //Endpoint de Producto
  static final String getProducto = '$baseUrl/Producto/Lista';
  static final String saveProducto = '$baseUrl/Producto/Guardar';
  static final String updateProducto = '$baseUrl/Producto/Editar';
  static final String deleteProducto = '$baseUrl/Producto/Eliminar';
  //Endpoint de Categoria Producto
  static final String getCategoria = '$baseUrl/Categoria/Lista';
  //Endpoint de Venta 
  static final String registerVenta = '$baseUrl/Venta/Registrar';
  static final String historial = '$baseUrl/Venta/Historial';
  static final String reporte = '$baseUrl/Venta/Reporte';
  //Endpoint de DashBoard
  static final String dashboard = '$baseUrl/DashBoard/Resumen';
  //Endpoint de Tareas 
  static final String gettareas = '$baseUrl/Tareas/Lista';
  static final String saveTarea = '$baseUrl/Tareas/Guardar';
  static final String updateTarea = '$baseUrl/Tareas/Editar';
  static final String completeTarea = '$baseUrl/Tareas/CompletarTarea';
  static final String inactivarTarea = '$baseUrl/Tareas/Inactivar_Tarea';
}
