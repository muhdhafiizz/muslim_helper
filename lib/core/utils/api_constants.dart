import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  static final String apiKey = dotenv.env['API_KEY'] ?? '';
  static const String baseUrl = "https://maps.googleapis.com/maps/api/place";
}
