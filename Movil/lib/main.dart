import 'package:flutter/material.dart';
import 'package:sistema_ventas_app_v1/src/routes/app_router.dart';
import 'src/app.dart';

void main(){
  setupNavigationService();//Agregamos esta linea para configurar el setup navigation service
  runApp(App());
}
