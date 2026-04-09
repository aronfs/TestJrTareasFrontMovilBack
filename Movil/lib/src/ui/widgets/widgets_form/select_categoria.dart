import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sistema_ventas_app_v1/src/blocs/categoria_bloc/categoria_bloc.dart';
import 'package:sistema_ventas_app_v1/src/blocs/rol_bloc/rol_bloc.dart';
import 'package:sistema_ventas_app_v1/src/models/categoria_model.dart';
class SelectCategoria extends StatefulWidget {
  final int? value; // Valor inicial del rol
  final Function(int?) onChanged;

  const SelectCategoria({
    super.key,
    required this.onChanged,
    this.value,
  });

  @override
  _SelectCategoriaState createState() => _SelectCategoriaState();
}

class _SelectCategoriaState extends State<SelectCategoria> {
  StreamSubscription<int?>? _subscription;
  int? _selectedRole;

  @override
  void initState() {
    super.initState();
    _selectedRole = widget.value; // Inicializa con el valor recibido

    // Escucha cambios en el stream
    _subscription = rolBloc.selectedRoleStream.listen((categoriaId) {
      if (mounted) {
        setState(() => _selectedRole = categoriaId);
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
    return StreamBuilder<List<CategoriaModel>>(
      stream: categoriaBloc.categorias,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }

        final categorias = snapshot.data!;

        return DropdownButton<int>(
          value: _selectedRole, // Usa el valor seleccionado
          isExpanded: true,
          hint: const Text('Selecciona una categoria'),
          items: categorias.map((categoria) {
            return DropdownMenuItem<int>(
              value: categoria.idCategoria,
              child: Text(categoria.nombre ?? 'No Hay Categorias'),
            );
          }).toList(),
          onChanged: (value) {
            categoriaBloc.seleccionarCategoria(value);
            widget.onChanged(value);
            setState(() => _selectedRole = value);
          },
        );
      },
    );
  }
}


