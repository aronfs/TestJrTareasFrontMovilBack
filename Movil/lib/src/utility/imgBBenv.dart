import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
class Imgbbenv {
  
Future<String> subirImagenAImgBB(File imagen) async {
  const String apiKey = "3a5bac554dfad3f333138987d7411b1a";
  const String url = "https://api.imgbb.com/1/upload?key=$apiKey";

  var request = http.MultipartRequest("POST", Uri.parse(url));
  request.files.add(await http.MultipartFile.fromPath("image", imagen.path));

  var response = await request.send();

  if (response.statusCode == 200) {
    var responseData = await response.stream.bytesToString();
    var jsonData = json.decode(responseData);

    String imageUrl = jsonData['data']['url'];
    print("✅ Imagen subida con éxito: $imageUrl");
    return imageUrl;
  } else {
    print("❌ Error al subir imagen: ${response.reasonPhrase}");
    throw Exception("Error al subir imagen: ${response.reasonPhrase}");
  }
}

}