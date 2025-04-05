import 'package:camera/camera.dart';
//import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

class Apiservice {
  // инициализация библиотек
  //final Dio _dio = Dio();
  final backend_link =
      'https://musical-parakeet-7g7jx75jx2w6jx-8000.app.github.dev/';

  // получение всех пользователей
  void getItems(XFile image) async {
    try {
      // final response = await _dio.post('${backend_link}track', data: {image});
      var request =
          http.MultipartRequest('POST', Uri.parse('${backend_link}track'));

      // Добавляем файл в запрос
      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          image.path,
        ),
      );

      // Отправляем запрос
      var response = await request.send();

      if (response.statusCode == 200) {
        var responseBody = await response.stream.bytesToString();
        print('Успешно загружено: $responseBody');
      } else {
        throw Exception('Error ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('$e');
    }
  }
}
