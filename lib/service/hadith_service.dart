import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/hadith_model.dart';
import 'package:flutter/material.dart';

class HadithService {
  static const String _apiKey =
      r'$2y$10$TKsgtaHWyFE3JUitdwd4MuWJlW6zAN9RXRCPwefGJmkmYKocL102a';

  static Future<List<HadithModel>> fetchHadiths({int page = 1, String query = ''}) async {
    final url = Uri.parse('https://hadithapi.com/api/hadiths/?apiKey=$_apiKey&page=$page&query=$query');
    debugPrint("Making API request to: $url");

    try {
      final response = await http.get(url);
      debugPrint("API Response Code: ${response.statusCode}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        
        if (responseData['hadiths'] == null || responseData['hadiths']['data'] == null) {
          debugPrint("No hadiths found in API response.");
          return [];
        }

        final hadithList = responseData['hadiths']['data'];
        debugPrint("Received ${hadithList.length} hadiths from API.");

        return (hadithList as List)
            .map((item) => HadithModel.fromJson(item))
            .toList();
      } else {
        debugPrint("API Error: ${response.statusCode} - ${response.body}");
        return [];
      }
    } catch (e) {
      debugPrint("Error fetching Hadiths: $e");
      return [];
    }
  }
}
