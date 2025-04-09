import 'package:flutter/foundation.dart';
import 'package:hadith_reader/providers/home_provider.dart';
import '../core/utils/map_helper.dart';
import '../model/masjid_detail_model.dart';
import '../service/masjid_locator_service.dart';


class MasjidProvider with ChangeNotifier {
  final MasjidLocatorService _masjidServce = MasjidLocatorService();
  final MapService _mapService = MapService();

  List<Masjid> masjids = [];
  bool isLoading = false;
  String errorMessage = "";

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
      final position = await HadithProvider
          .determinePosition();
      final lat = position.latitude;
      final lng = position.longitude;

      print("Here is $lat");
      print("Here is $lng");


      masjids = await _masjidServce.getNearbyMasjids(lat, lng);
    } catch (e) {
      errorMessage = e.toString();
      masjids = [];
      debugPrint("Exception: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> openMap(double lat, double lng) async {
    await _mapService.openMap(lat, lng);
  }
}
