import 'package:flutter/material.dart';
import 'package:sistema_ventas_app_v1/src/models/usuario_model.dart';
import 'package:sistema_ventas_app_v1/src/routes/app_routes.dart';
import 'package:sistema_ventas_app_v1/src/services/usuario_service.dart';
import 'package:sistema_ventas_app_v1/src/utility/navigation_service.dart';

class UsuarioItem extends StatelessWidget {
  final UsuarioModel usuario;
  final UsuarioService usuarioService;

  const UsuarioItem({
    super.key,
    required this.usuario,
    required this.usuarioService,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 30,
        backgroundColor: Colors.grey[300],
        child: usuario.foto != null && usuario.foto!.isNotEmpty
            ? ClipOval(
                child: Image.network(
                  usuario.foto!,
                  fit: BoxFit.cover,
                  width: 60,
                  height: 60,
                  errorBuilder: (context, error, stackTrace) => 
                      const Icon(Icons.person, size: 40),
                ),
              )
            : const Icon(Icons.person, size: 40),
      ),
      title: Text(usuario.nombreCompleto),
      subtitle: Text(usuario.correo),
      trailing: Wrap(
        spacing: 5,
        children: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.blueAccent),
            onPressed: () {
              navigationService.navigateTo(
                AppRoutes.usuarioForm,
                arguments: usuario,
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.redAccent),
            onPressed: () => _confirmarEliminacion(context),
          ),
        ],
      ),
    );
  }

  /// Muestra un diálogo de confirmación antes de eliminar
  Future<void> _confirmarEliminacion(BuildContext context) async {
    final confirmacion = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar usuario'),
        content: const Text('¿Estás seguro de que deseas eliminar este usuario?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmacion == true) {
      if (!context.mounted) return; // Evita errores si el contexto se desmonta
      await usuarioService.eliminarUsuario(context: context, idUsuario: usuario.idUsuario!);
      
    }
  }
}
