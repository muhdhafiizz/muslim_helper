import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../core/utils/api_constants.dart';
import '../model/masjid_detail_model.dart';

class MasjidLocatorService {
  Future<List<Masjid>> getNearbyMasjids(double lat, double lng) async {
    final url = Uri.parse(
        "${ApiConstants.baseUrl}/nearbysearch/json?location=$lat,$lng&radius=5000&type=mosque&key=${ApiConstants.apiKey}");

    debugPrint("Fetching nearby masjids from: $url");

    final response = await http.get(url);

    debugPrint("Response status: ${response.statusCode}");
    debugPrint("Response body: ${response.body}");

    final data = json.decode(response.body);

    if (data["status"] == "OK") {
      final masjids = (data["results"] as List)
          .map((json) => Masjid.fromJson(json))
          .toList();

      debugPrint("Masjids fetched: ${masjids.length}");
      return masjids;
    } else {
      debugPrint("Error fetching masjids: ${data["status"]}");
      throw Exception("Failed to fetch masjids: ${data["status"]}");
    }
  }
}
