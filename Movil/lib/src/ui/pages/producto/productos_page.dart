import 'package:flutter/material.dart';
import 'package:sistema_ventas_app_v1/src/blocs/producto_bloc/producto_bloc.dart';
import 'package:sistema_ventas_app_v1/src/models/producto_model.dart';
import 'package:sistema_ventas_app_v1/src/routes/app_routes.dart';
import 'package:sistema_ventas_app_v1/src/services/producto_service.dart';
import 'package:sistema_ventas_app_v1/src/ui/widgets/ProductoPage_widget/producto_list.dart';
import 'package:sistema_ventas_app_v1/src/utility/navigation_service.dart';



class ProductosPage extends StatefulWidget {
  const ProductosPage({super.key});

  @override
  State<ProductosPage> createState() => _ProductosPageState();
}

class _ProductosPageState extends State<ProductosPage> {
  final ProductoService _productoService = ProductoService();

  @override
  void initState() {
    super.initState();
    _productoService.cargarProductosConCategorias(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Productos'),
      ),
      body: StreamBuilder<List<ProductoModel>>(
        stream: productoBloc.productosStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final productos = snapshot.data ?? [];
          return ProductoList(productos: productos);
        },
      ),
       floatingActionButton: FloatingActionButton(
        onPressed:(){
           navigationService.pushNamed(AppRoutes.productoForm);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
