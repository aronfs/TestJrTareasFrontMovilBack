import 'package:flutter/material.dart';

class EmailField extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const EmailField({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
        labelText: 'Correo corporativo',
        hintText: 'nombre@empresa.com',
        prefixIcon: Icon(Icons.alternate_email_rounded),
      ),
    );
  }
}
