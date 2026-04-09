import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sistema_ventas_app_v1/src/models/usuario_model.dart';

class ProfileInfo extends StatelessWidget {
  final UsuarioModel usuario;

  const ProfileInfo({
    super.key,
    required this.usuario,
  });

  @override
  Widget build(BuildContext context) {
    String qrData = '''
    Nombre: ${usuario.nombreCompleto}
    Correo: ${usuario.correo}
    Rol: ${usuario.idRol}
    Estado: ${usuario.esActivo == 1 ? 'Activo' : 'Inactivo'}
    ''';

    return Column(
      children: [
        Text('Nombre: ${usuario.nombreCompleto}'),
        Text('Correo: ${usuario.correo}'),
        Text('Rol: ${usuario.idRol}'),
        Text('Estado: ${usuario.esActivo == 1 ? 'Activo' : 'Inactivo'}'),
        const SizedBox(height: 20),
        QrImageView(
          data: qrData,
          version: QrVersions.auto,
          size: 200.0,
        ),
      ],
    );
  }
}
