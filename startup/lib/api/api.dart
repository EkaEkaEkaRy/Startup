import 'dart:convert';

import 'package:camera/camera.dart';
//import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

class Apiservice {
  // инициализация библиотек
  //final Dio _dio = Dio();
  final backend_link =
      'https://musical-parakeet-7g7jx75jx2w6jx-8000.app.github.dev/';

  // получение всех пользователей
  Future<List> getItems(XFile image) async {
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
        final responseBody = await response.stream.bytesToString();
        final answer_json = jsonDecode(jsonDecode(responseBody));
        return answer_json;
      } else {
        throw Exception('Error ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('$e');
    }
  }

  Future<String> getPrice(String className) async {
    final response =
        await http.get(Uri.parse('${backend_link}price?class_name=$className'));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load price');
    }
  }
}
