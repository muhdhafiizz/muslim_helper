import 'package:flutter/foundation.dart';
import 'package:hadith_reader/providers/home_provider.dart';
import '../core/utils/location_helper.dart';
import '../core/utils/map_helper.dart';
import '../model/masjid_detail_model.dart';
import '../service/masjid_locator_service.dart';

class MasjidProvider with ChangeNotifier {
  final MasjidLocatorService _masjidServce = MasjidLocatorService();
  final MapService _mapService = MapService();

  List<Masjid> masjids = [];
  bool isLoading = false;
  String errorMessage = "";
  double? currentLat;
  double? currentLng;

  MasjidProvider() {
    fetchMasjids();
  }

  Future<void> fetchMasjids() async {
    if (isLoading) return;

    isLoading = true;
    errorMessage = "";
    notifyListeners();

    try {
      debugPrint("Fetching current location...");
      final position = await HadithProvider.determinePosition();
      currentLat = position.latitude;
      currentLng = position.longitude;

      masjids = await _masjidServce.getNearbyMasjids(currentLat!, currentLng!);

      masjids.sort((a, b) {
        final distanceA = LocationHelper.calculateDistance(
          currentLat!,
          currentLng!,
          a.latitude,
          a.longitude,
        );
        final distanceB = LocationHelper.calculateDistance(
          currentLat!,
          currentLng!,
          b.latitude,
          b.longitude,
        );
        return distanceA.compareTo(distanceB);
      });
    } catch (e, stacktrace) {
      errorMessage = e.toString();
      masjids = [];
      debugPrint("Exception: $e");
      debugPrint("Stacktrace: $stacktrace");
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> openMap(double lat, double lng) async {
    await _mapService.openMap(lat, lng);
  }
}
