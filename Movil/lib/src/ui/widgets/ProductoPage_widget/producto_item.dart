import 'package:flutter/material.dart';
import 'package:sistema_ventas_app_v1/src/models/producto_model.dart';
import 'package:sistema_ventas_app_v1/src/routes/app_routes.dart';
import 'package:sistema_ventas_app_v1/src/services/producto_service.dart';
import 'package:sistema_ventas_app_v1/src/utility/navigation_service.dart';

class ProductoItem extends StatelessWidget {
  final ProductoModel producto;
  final ProductoService productoService;

  const ProductoItem({
    super.key,
    required this.producto,
    required this.productoService,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 30,
        backgroundColor: Colors.grey[300],
        child: producto.foto != null && producto.foto!.isNotEmpty
            ? ClipOval(
                child: Image.network(
                  producto.foto!,
                  fit: BoxFit.cover,
                  width: 60,
                  height: 60,
                  errorBuilder: (context, error, stackTrace) => 
                      const Icon(Icons.person, size: 40),
                ),
              )
            : const Icon(Icons.person, size: 40),
      ),
      title: Text(producto.nombre ?? 'Nombre no disponible'),
      subtitle: Text(producto.descripcionCategoria ?? 'Descripción no disponible'),
      trailing: Wrap(
        spacing: 5,
        children: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.blueAccent),
            onPressed: () {
              navigationService.navigateTo(
                AppRoutes.productoForm,
               arguments: producto,
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
        title: const Text('Eliminar producto'),
        content: const Text('¿Estás seguro de que deseas eliminar este producto?'),
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
      if (!context.mounted) return; 
      // Evita errores si el contexto se desmonta
      
      await productoService.eliminarProducto(context: context, idProducto: producto.idProducto);
      print("IdPRoducto: ${producto.idProducto}");
    }
  }
}
