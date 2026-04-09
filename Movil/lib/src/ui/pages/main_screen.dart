import 'package:flutter/material.dart';
import 'package:sistema_ventas_app_v1/src/blocs/menu_bloc/menu_bloc.dart';
import 'package:sistema_ventas_app_v1/src/models/menu_model.dart';
import 'package:sistema_ventas_app_v1/src/routes/app_routes.dart';
import 'package:sistema_ventas_app_v1/src/services/main_service.dart';
import 'package:sistema_ventas_app_v1/src/theme/app_theme.dart';
import 'package:sistema_ventas_app_v1/src/ui/widgets/MainScreen_widgets/custom_barra_navegacion.dart';
import 'package:sistema_ventas_app_v1/src/ui/widgets/MainScreen_widgets/menu_widgets.dart';
import 'package:sistema_ventas_app_v1/src/utility/navigation_service.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _DynamicMenuState();
}

class _DynamicMenuState extends State<MainScreen> {
  int _selectedIndex = 0;
  final MainService _mainService = MainService();

  @override
  void initState() {
    super.initState();
    _mainService.CargarMenusConDatosUsuario();
    menuBloc.menus.listen(
      (menus) => print('Menus actualizados: $menus'),
      onError: (error) => print('Error al recibir los menus: $error'),
    );
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<MenuModel>>(
      stream: menuBloc.menus,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final menus = snapshot.data!;
        final currentUrl = menus[_selectedIndex].url;
        return Scaffold(
          extendBody: true,
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFF7F3EA), Color(0xFFF0E9DD)],
              ),
            ),
            child: SafeArea(
              bottom: false,
              child:
                  menuWidgets[menus[_selectedIndex].url] ??
                  const Center(child: Text('Pagina no encontrada')),
            ),
          ),
          bottomNavigationBar: CustomBarraNavegacion(
            selectedIndex: _selectedIndex,
            onItemTapped: _onItemTapped,
            menus: menus,
          ),
          floatingActionButton: currentUrl == '/pages/tareas'
              ? FloatingActionButton.extended(
                  onPressed: () {
                    navigationService.pushNamed(AppRoutes.tareasForm);
                  },
                  backgroundColor: AppTheme.ink,
                  foregroundColor: AppTheme.paper,
                  icon: const Icon(Icons.add_task_rounded),
                  label: const Text('Nueva tarea'),
                )
              : null,
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        );
      },
    );
  }

  @override
  void dispose() {
    print('Liberando recursos de MainScreen');
    super.dispose();
  }
}
