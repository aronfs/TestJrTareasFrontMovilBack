import 'package:flutter/material.dart';
import 'package:sistema_ventas_app_v1/src/blocs/usuario_bloc/usuario_bloc.dart';
import 'package:sistema_ventas_app_v1/src/models/usuario_model.dart';
import 'package:sistema_ventas_app_v1/src/services/usuario_service.dart';
import 'package:sistema_ventas_app_v1/src/ui/widgets/ProfilePage_widgets/foto_usuario.dart';
import 'package:sistema_ventas_app_v1/src/ui/widgets/ProfilePage_widgets/profile_info.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final UsuarioService _usuarioService = UsuarioService();

  @override
  void initState() {
    super.initState();
    _usuarioService.initUsuarioListener(context);
  }

  @override
  void dispose() {
    usuarioBloc.dispose(); // Limpiar streams
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Perfil')),
      body: StreamBuilder<UsuarioModel?>(
        stream: usuarioBloc.usuario,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('No hay datos de usuario'));
          }

          final usuario = snapshot.data!;

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FotoUsuario(fotoBase64: usuario.foto ?? ''),
                ProfileInfo(usuario: usuario,),
                const SizedBox(height: 20),
               
              ],
            ),
          );
        },
      ),
    );
  }
}
