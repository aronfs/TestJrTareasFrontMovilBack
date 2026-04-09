// usuario_lista.dart
import 'package:flutter/material.dart';
import 'package:sistema_ventas_app_v1/src/models/usuario_model.dart';
import 'usuario_item.dart';
import 'package:sistema_ventas_app_v1/src/services/usuario_service.dart'; // Adjust the path if necessary

class UsuarioLista extends StatelessWidget {
  final List<UsuarioModel> usuarios;

  const UsuarioLista({super.key, required this.usuarios});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: usuarios.length,
      itemBuilder: (context, index) {
        return UsuarioItem(
          usuario: usuarios[index],
          usuarioService: UsuarioService() // Replace with the actual instance or method to get the service
        );
      },
    );
  }
}
