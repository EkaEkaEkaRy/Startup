import 'package:camera/camera.dart';
import 'package:dio/dio.dart';

class Apiservice {
  // инициализация библиотек
  final Dio _dio = Dio();
  final backend_link =
      'https://musical-parakeet-7g7jx75jx2w6jx-8000.app.github.dev/';

  // получение всех пользователей
  void getItems(XFile image) async {
    try {
      final response = await _dio.post('${backend_link}track', data: {image});
      if (response.statusCode == 200) {
        print(response.data);
      } else {
        throw Exception('Error ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('$e');
    }
  }
}
