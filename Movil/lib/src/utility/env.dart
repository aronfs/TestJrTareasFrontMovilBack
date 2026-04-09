class Env {
  static const String enviroment = String.fromEnvironment('ENV', defaultValue: 'dev');


  static String get baseUrl {
    switch (enviroment) {
        //url para Dispositivo Fisico
      case 'dev':
      //return 'http://0.0.0.0:5185/api';
        return 'http://192.168.0.157:5185/api';
        //url para Emulador Android
      case 'dev2':
        //return 'http://10.0.2.2:5185';
      default:
        return 'Url no encontrada';
    }
  }

}