import 'package:flutter_dotenv/flutter_dotenv.dart';

class Config {
  static String get serviceKey => dotenv.env['ServiceKey'] ?? '';
}