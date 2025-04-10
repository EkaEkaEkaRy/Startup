import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static Future<void> load() async {
    await dotenv.load(fileName: '.env');
  }

  static String get backendUrl => dotenv.env['BACKEND_URL'] ?? '';
}
