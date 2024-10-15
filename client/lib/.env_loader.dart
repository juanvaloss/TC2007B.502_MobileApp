import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvLoader {
  static String get googleMapsApiKey {
    return dotenv.env['GOOGLE_MAPS_API_KEY'] ?? '';
  }
}