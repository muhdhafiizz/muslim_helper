import 'dart:convert';
import 'package:hadith_reader/model/prayer_time_model.dart';
import 'package:http/http.dart' as http;

class PrayerTimingsService {
  static Future<PrayerTimings> getPrayerTimings(
      String date, String latitude, String longitude) async {
    final String url =
        "https://api.aladhan.com/v1/timings/$date?latitude=$latitude&longitude=$longitude";

    final response = await http.get(Uri.parse(url));

    print("API Request URL: $url");
    print("API Response: ${response.body}");

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data.containsKey('data')) {
        return PrayerTimings.fromJson(data['data']);
      } else {
        throw Exception("Invalid API response format");
      }
    } else {
      throw Exception("Failed to load prayer timings");
    }
  }
}

