// widgets/menu_widgets.dart
import 'package:flutter/material.dart';
import 'package:sistema_ventas_app_v1/src/ui/pages/dash-board/dashboard_page.dart';
import 'package:sistema_ventas_app_v1/src/ui/pages/historial-venta/historial_venta_page.dart';
import 'package:sistema_ventas_app_v1/src/ui/pages/producto/productos_page.dart';
import 'package:sistema_ventas_app_v1/src/ui/pages/reporte/reporte_page.dart';
import 'package:sistema_ventas_app_v1/src/ui/pages/tareas/tareas_page.dart';
import 'package:sistema_ventas_app_v1/src/ui/pages/usuarios/usuario_page.dart';
import 'package:sistema_ventas_app_v1/src/ui/pages/venta/venta_page.dart';

// Map de rutas a Widgets
final Map<String, Widget> menuWidgets = {
  '/pages/dashboard': DashboardPage(),
  '/pages/usuarios': UsuarioPage(),
  '/pages/reportes': ReportePage(),
  '/pages/productos': ProductosPage(),
  '/pages/venta': VentaPage(),
  '/pages/historial_venta': HistorialVentaPage(),
  '/pages/tareas': TareasPage()
};

// Map de nombres de iconos a IconData
final Map<String, IconData> iconMap = {
  "dashboard": Icons.dashboard,
  "group": Icons.group,
  "collections_bookmark": Icons.collections_bookmark,
  "currency_exchange": Icons.currency_exchange,
  "edit_note": Icons.edit_note,
  "receipt": Icons.receipt,
  "settings": Icons.settings,
  "home": Icons.home,
  "person": Icons.person,
};
