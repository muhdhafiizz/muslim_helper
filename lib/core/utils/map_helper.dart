import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

class MapService {
  Future<void> openMap(double lat, double lng) async {
    final googleMapsUrl = Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lng');
    final wazeUrl = Uri.parse('https://waze.com/ul?ll=$lat,$lng&navigate=yes');

    try {
      if (await canLaunchUrl(googleMapsUrl)) {
        await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
      } else if (await canLaunchUrl(wazeUrl)) {
        await launchUrl(wazeUrl, mode: LaunchMode.externalApplication);
      } else {
        debugPrint("Could not launch any map application.");
        throw 'Could not launch map';
      }
    } catch (e) {
      debugPrint("Error launching map: $e");
    }
  }
}
