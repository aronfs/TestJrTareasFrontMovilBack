// usuario_page.dart
import 'package:flutter/material.dart';
import 'package:sistema_ventas_app_v1/src/blocs/usuario_bloc/usuario_bloc.dart';
import 'package:sistema_ventas_app_v1/src/models/usuario_model.dart';
import 'package:sistema_ventas_app_v1/src/routes/app_routes.dart';
import 'package:sistema_ventas_app_v1/src/services/usuario_service.dart';
import 'package:sistema_ventas_app_v1/src/ui/widgets/UsuarioPage_widgets/usuario_lista.dart';
import 'package:sistema_ventas_app_v1/src/utility/navigation_service.dart';


class UsuarioPage extends StatefulWidget {
  const UsuarioPage({super.key});

  @override
  State<UsuarioPage> createState() => _UsuarioPageState();
}

class _UsuarioPageState extends State<UsuarioPage> {
  final UsuarioService _usuarioService = UsuarioService();
  
  @override
  void initState() {
    super.initState();
    _usuarioService.CargarUsuarios(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Usuarios'),
      ),
      body: StreamBuilder<List<UsuarioModel>>(
        stream: usuarioBloc.usuariosStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final usuarios = snapshot.data ?? [];
          return UsuarioLista(usuarios: usuarios);
        },
      ),
       floatingActionButton: FloatingActionButton(
        onPressed:(){
           navigationService.pushNamed(AppRoutes.usuarioForm);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
