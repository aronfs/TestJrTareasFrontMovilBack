// lib/src/utility/jwt_utils.dart
import 'dart:convert';

class JwtUtils {
  // Decodificar el token y extraer el correo
  static String? obtenerCorreoDesdeToken(String token) {
    try {
      final partes = token.split('.');
      if (partes.length != 3) {
        print('⚠️ Token inválido: formato incorrecto.');
        return null;
      }

      // Decodificar el payload (Base64 a JSON)
      final payloadBase64 = partes[1];
      final payloadString = utf8.decode(base64Url.decode(_ajustarPadding(payloadBase64)));
      final Map<String, dynamic> payload = json.decode(payloadString);

      // Extraer el correo según el claim
      const claimCorreo = 'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress';
      return payload[claimCorreo];
    } catch (e) {
      print('❌ Error al decodificar el token: $e');
      return null;
    }
  }

   static String obtnereIDUserToken(String token) {
    try {
      final partes = token.split('.');
      if (partes.length != 3) {
        print('⚠️ Token inválido: formato incorrecto.');
        return '';
      }

      // Decodificar el payload (Base64 a JSON)
      final payloadBase64 = partes[1];
      final payloadString = utf8.decode(base64Url.decode(_ajustarPadding(payloadBase64)));
      final Map<String, dynamic> payload = json.decode(payloadString);

      // Extraer el correo según el claim
      const claimCorreo = 'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier';
      //print("aqui error"+claimCorreo);
      return payload[claimCorreo];
    } catch (e) {
      print('❌ Error al decodificar el token: $e');
      return '';
    }
  }

  // Ajustar el padding del Base64 si es necesario
  static String _ajustarPadding(String base64) {
    while (base64.length % 4 != 0) {
      base64 += '=';
    }
    return base64;
  }
}
