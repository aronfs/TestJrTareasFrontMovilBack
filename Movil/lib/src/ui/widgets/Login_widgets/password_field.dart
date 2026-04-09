import 'package:flutter/material.dart';

class PasswordField extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const PasswordField({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      obscureText: true,
      decoration: const InputDecoration(
        labelText: 'Contrasena',
        hintText: 'Ingresa tu contrasena',
        prefixIcon: Icon(Icons.lock_outline_rounded),
        suffixIcon: Icon(Icons.visibility_off_outlined),
      ),
    );
  }
}
