import 'dart:async';
import 'auth_api_provider.dart';
import '../models/auth_model.dart';

class Repository {

  final authApiProvider = AuthApiProvider();

  Future<AuthModel> fetchToken(AuthModel authModel) => authApiProvider.fetchToken(authModel);


}