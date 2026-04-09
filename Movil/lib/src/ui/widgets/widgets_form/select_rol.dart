import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sistema_ventas_app_v1/src/blocs/rol_bloc/rol_bloc.dart';
import 'package:sistema_ventas_app_v1/src/models/rol_model.dart';
class SelectRol extends StatefulWidget {
  final int? value; // Valor inicial del rol
  final Function(int?) onChanged;

  const SelectRol({
    super.key,
    required this.onChanged,
    this.value,
  });

  @override
  _SelectRolState createState() => _SelectRolState();
}

class _SelectRolState extends State<SelectRol> {
  StreamSubscription<int?>? _subscription;
  int? _selectedRole;

  @override
  void initState() {
    super.initState();
    _selectedRole = widget.value; // Inicializa con el valor recibido

    // Escucha cambios en el stream
    _subscription = rolBloc.selectedRoleStream.listen((roleId) {
      if (mounted) {
        setState(() => _selectedRole = roleId);
      }
    });
  }

  @override
  void dispose() {
    _subscription?.cancel(); // Cancela la suscripción al salir
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<RolModel>>(
      stream: rolBloc.rol,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }

        final roles = snapshot.data!;

        return DropdownButton<int>(
          value: _selectedRole, // Usa el valor seleccionado
          isExpanded: true,
          hint: const Text('Selecciona un rol'),
          items: roles.map((rol) {
            return DropdownMenuItem<int>(
              value: rol.idRol,
              child: Text(rol.nombre ?? 'Unknown'),
            );
          }).toList(),
          onChanged: (value) {
            rolBloc.selectRole(value);
            widget.onChanged(value);
            setState(() => _selectedRole = value);
          },
        );
      },
    );
  }
}


