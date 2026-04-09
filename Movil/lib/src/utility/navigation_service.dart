import 'package:go_router/go_router.dart';


class NavigationService {
  static final NavigationService _instance = NavigationService._internal();
  factory NavigationService() => _instance;
  NavigationService._internal();
  late GoRouter _router;

  void setRouter(GoRouter router) {
    _router = router;
  }

  //Vamos hacia a la super Ruta
  void goToPath(String path) {
    _router.go(path);
  }
//Aqui va
  void navigateTo(String path, {Object? arguments}){
    _router.push(path, extra: arguments);
  }
  //Empujamos una nueva Ruta
  void pushNamed(String path) {
    _router.push(path);
  }

}

final navigationService = NavigationService();

