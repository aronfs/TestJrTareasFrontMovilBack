import 'package:flutter/material.dart';

class FotoUsuario extends StatelessWidget {
  final String fotoBase64;

  const FotoUsuario({super.key, required this.fotoBase64});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircleAvatar(
        radius: 50, // Imagen más grande
        backgroundColor: Colors.grey[300],
        child: fotoBase64.isNotEmpty
            ? ClipOval(
                child: Image.network(
                  fotoBase64,
                  fit: BoxFit.cover,
                  width: 100, // Asegura que ocupe bien el espacio
                  height: 100,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.person, size: 50), // Ícono de respaldo
                ),
              )
            : const Icon(Icons.person, size: 50),
      ),
    );
  }
}
