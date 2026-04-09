// usuario_lista.dart
import 'package:flutter/material.dart';
import 'package:sistema_ventas_app_v1/src/models/producto_model.dart';
import 'package:sistema_ventas_app_v1/src/services/producto_service.dart';
import 'package:sistema_ventas_app_v1/src/ui/widgets/ProductoPage_widget/producto_item.dart'; // Adjust the path if necessary

class ProductoList extends StatelessWidget {
  final List<ProductoModel> productos;

  const ProductoList({super.key, required this.productos});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: productos.length,
      itemBuilder: (context, index) {
        return ProductoItem(
          producto: productos[index],
          productoService: ProductoService() // Replace with the actual instance or method to get the service
        );
      },
    );
  }
}
