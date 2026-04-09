import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sistema_ventas_app_v1/src/blocs/producto_bloc/producto_bloc.dart';
import 'package:sistema_ventas_app_v1/src/blocs/rol_bloc/rol_bloc.dart';
import 'package:sistema_ventas_app_v1/src/models/producto_model.dart';
class SelectProducto extends StatefulWidget {
  final int? value; // Valor inicial del rol
  final Function(int?) onChanged;

  const SelectProducto({
    super.key,
    required this.onChanged,
    this.value,
  });

  @override
  _SelectProductoState createState() => _SelectProductoState();
}

class _SelectProductoState extends State<SelectProducto> {
  StreamSubscription<int?>? _subscription;
  int? _selectedRole;

  @override
  void initState() {
    super.initState();
    _selectedRole = widget.value; // Inicializa con el valor recibido

    // Escucha cambios en el stream
    _subscription = rolBloc.selectedRoleStream.listen((idProducto) {
      if (mounted) {
        setState(() => _selectedRole = idProducto);
      }
    });
  }

  @override
  void dispose() {
    _subscription?.cancel(); // Cancela la suscripción al salir
    super.dispose();
  }

  @override
 @override
Widget build(BuildContext context) {
  return StreamBuilder<List<ProductoModel>>(
    stream: productoBloc.productosStream,
    builder: (context, snapshot) {
      if (!snapshot.hasData) {
        return const CircularProgressIndicator();
      }

      List<ProductoModel> productos = snapshot.data!;

      // Verificar si hay IDs duplicados
      Set<int> idsVistos = {};
      List<ProductoModel> productosUnicos = [];
      for (var producto in productos) {
        if (!idsVistos.contains(producto.idProducto)) {
          idsVistos.add(producto.idProducto);
          productosUnicos.add(producto);
        } else {
          print("⚠️ Producto duplicado detectado: ${producto.idProducto}");
        }
      }

      // Asegurar que _selectedRole sea un valor válido
      if (!productosUnicos.any((p) => p.idProducto == _selectedRole)) {
        _selectedRole = null;
      }

      return DropdownButton<int>(
        value: _selectedRole,
        isExpanded: true,
        hint: const Text('Selecciona un producto'),
        items: productosUnicos.map((producto) {
          return DropdownMenuItem<int>(
            value: producto.idProducto,
            child: Text(producto.nombre ?? 'Producto sin nombre'),
          );
        }).toList(),
        onChanged: (value) {
          productoBloc.seleccionarProducto(value);
          widget.onChanged(value);
          setState(() => _selectedRole = value);
        },
      );
    },
  );
}

}


